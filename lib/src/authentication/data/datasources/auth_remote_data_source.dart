import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/user_enums.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/constans.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}

class AuthRemoteDataSrcImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSrcImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw APIException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return UserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, email);

      userData = await _getUserData(user.uid);

      return UserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } on APIFailure {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCreate = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCreate.user?.updateDisplayName(fullName);
      await userCreate.user?.updatePhotoURL(kDefaultAvatar);

      await _setUserData(
        _firebaseAuth.currentUser!,
        email,
      );
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _firebaseAuth.currentUser?.updateEmail(userData as String);
          await _updateUser({'email': userData});
        case UpdateUserAction.userName:
          await _firebaseAuth.currentUser
              ?.updateDisplayName(userData as String);
          await _updateUser({'fullName': userData});
        case UpdateUserAction.profilePic:
          final ref = _storage
              .ref()
              .child('profile_pics/${_firebaseAuth.currentUser?.uid}');

          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _firebaseAuth.currentUser?.updatePhotoURL(url);
          await _updateUser({'profilePic': url});
        case UpdateUserAction.password:
          if (_firebaseAuth.currentUser?.email == null) {
            throw APIException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }

          final newData = jsonDecode(userData as String) as DataMap;
          await _firebaseAuth.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _firebaseAuth.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );

          await _firebaseAuth.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
        case UpdateUserAction.bio:
          await _updateUser({'bio': userData as String});
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _firestore.collection('users').doc(user.uid).set(
          UserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            points: 0,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUser(DataMap data) async {
    await _firestore
        .collection('users')
        .doc(
          _firebaseAuth.currentUser?.uid,
        )
        .update(data);
  }
}
