import 'dart:io';

import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_data_source.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_dto.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MaterialRemoteDataSrc remoteDataSrc;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  final tMaterial = ResourceModel.empty();

  setUp(() async {
    firestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    storage = MockFirebaseStorage();

    remoteDataSrc = MaterialRemoteDataSrcImpl(
      auth: auth,
      firestore: firestore,
      storage: storage,
    );
  });

  group('addMaterial', () {
    setUp(() async {
      await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .set(CourseModel.empty().toMap());
    });

    test('should add the provide [Material] to the firestore', () async {
      await remoteDataSrc.addMaterial(tMaterial);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .collection('materials')
          .get();

      expect(collectionRef.docs.length, equals(1));
    });

    test('should add the provided [Material] to the storage', () async {
      final materialFile = File('assets/images/default_user.png');

      final material =
          tMaterial.copyWith(isFile: true, fileURL: materialFile.path);

      await remoteDataSrc.addMaterial(material);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .collection('materials')
          .get();

      expect(collectionRef.docs.length, equals(1));

      final savedMaterial = collectionRef.docs.first.data();

      final storageMaterialURL = await storage
          .ref()
          .child(
            'courses/${tMaterial.courseId}/materials/${savedMaterial['id']}/material',
          )
          .getDownloadURL();

      expect(savedMaterial['fileURL'], equals(storageMaterialURL));
    });

    test('should throw a [APIException] when there is an error', () async {
      final call = remoteDataSrc.addMaterial;
      expect(() => call(Resource.empty()), throwsA(isA<APIException>()));
    });
  });

  group('getMaterials', () {
    test('should return a list of [Material] from the firestore', () async {
      await firestore
          .collection('courses')
          .doc(tMaterial.courseId)
          .set(CourseModel.empty().toMap());

      await remoteDataSrc.addMaterial(tMaterial);

      final result = await remoteDataSrc.getMaterials(tMaterial.courseId);

      expect(result, isA<List<Resource>>());
      expect(result.length, equals(1));
      expect(result.first.description, equals(tMaterial.description));
    });

    test('should return an empty list when there is an error', () async {
      final result = await remoteDataSrc.getMaterials(tMaterial.courseId);

      expect(result, isA<List<Resource>>());
      expect(result.isEmpty, isTrue);
    });
  });
}
