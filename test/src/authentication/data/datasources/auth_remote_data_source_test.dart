import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/user_enums.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/utils/constans.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseFirestore cloudStoreClient;
  late FirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource remoteDataSource;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;

  const tUser = UserModel.empty();

  setUp(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    authClient = MockFirebaseAuth();
    dbClient = MockFirebaseStorage();

    documentReference = cloudStoreClient.collection('users').doc();

    await documentReference
        .set(tUser.copyWith(uid: documentReference.id).toMap());

    mockUser = MockUser().._uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);

    remoteDataSource = AuthRemoteDataSrcImpl(
      firebaseAuth: authClient,
      firestore: cloudStoreClient,
      storage: dbClient,
    );

    when(
      () => authClient.currentUser,
    ).thenReturn(mockUser);
  });

  const tPassword = 'test password';
  const tFullName = 'jhon';
  const tEmail = 'jhon@somedomain.com';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifire',
  );

  group('forget password', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenAnswer((_) async => Future.value());

      final call = remoteDataSource.forgotPassword(tEmail);

      expect(call, completes);

      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });

    test('should return [APIException] when [FirebaseAuthException] is thrown',
        () async {
      when(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenThrow(tFirebaseAuthException);

      final call = remoteDataSource.forgotPassword;

      expect(() => call(tEmail), throwsA(isA<APIException>()));

      verify(
        () => authClient.sendPasswordResetEmail(email: tEmail),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });
  });

  group('Sign in', () {
    test('should return [UserModel] when no [Exception] is thrown', () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(
            named: 'password',
          ),
        ),
      ).thenAnswer((_) async => userCredential);

      final result = await remoteDataSource.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result.uid, userCredential.user!.uid);
      expect(result.points, 0);

      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should return [APIException] when [FirebaseException] is thrown',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(
            named: 'password',
          ),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = remoteDataSource.signIn;

      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<APIException>()),
      );

      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });

    test('should return [APIException] when user is null after signing in',
        () async {
      final emptyUserCredential = MockUserCredential();

      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(
            named: 'password',
          ),
        ),
      ).thenAnswer((_) async => emptyUserCredential);

      final call = remoteDataSource.signIn;

      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(
          isA<APIException>(),
        ),
      );

      verify(
        () => authClient.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });
  });

  group('Sign Up', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      when(
        () => userCredential.user?.updateDisplayName(
          any(),
        ),
      ).thenAnswer((_) async => Future.value());

      when(
        () => userCredential.user?.updatePhotoURL(
          any(),
        ),
      ).thenAnswer((_) async => Future.value());

      final call = remoteDataSource.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      );

      expect(call, completes);

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      await untilCalled(
        () => userCredential.user?.updateDisplayName(any()),
      );
      await untilCalled(
        () => userCredential.user?.updatePhotoURL(any()),
      );

      verify(
        () => userCredential.user?.updateDisplayName(tFullName),
      ).called(1);
      verify(
        () => userCredential.user?.updatePhotoURL(kDefaultAvatar),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });
    test('should throw [APIException] when [FirebaseAuthException] is thrown',
        () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = remoteDataSource.signUp;

      expect(
        () => call(email: tEmail, password: tPassword, fullName: tFullName),
        throwsA(
          isA<APIException>(),
        ),
      );

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });
  });

  group('Update User', () {
    setUp(
      () {
        registerFallbackValue(MockAuthCredential());
      },
    );
    test(
        'should update user displayName successfully when no [Exception] is '
        'thrown', () async {
      when(
        () => mockUser.updateDisplayName(any()),
      ).thenAnswer((_) async => Future.value());

      await remoteDataSource.updateUser(
        action: UpdateUserAction.userName,
        userData: tFullName,
      );

      verify(
        () => mockUser.updateDisplayName(tFullName),
      );

      verifyNever(
        () => mockUser.updateEmail(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );

      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(userData.data()!['fullName'], tFullName);
    });

    test('should update user email successfully when no [Exception] is thrown',
        () async {
      when(
        () => mockUser.updateEmail(any()),
      ).thenAnswer((_) async => Future.value());

      await remoteDataSource.updateUser(
        action: UpdateUserAction.email,
        userData: tEmail,
      );

      verify(
        () => mockUser.updateEmail(tEmail),
      ).called(1);

      verifyNever(
        () => mockUser.updateDisplayName(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );

      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();

      expect(userData.data()!['email'], tEmail);
    });

    test('should update user bio successfully when no [Exception] is thrown',
        () async {
      const newBio = 'new bio';

      await remoteDataSource.updateUser(
        action: UpdateUserAction.bio,
        userData: newBio,
      );

      verifyNever(
        () => mockUser.updateDisplayName(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updateEmail(any()),
      );

      final userData = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();

      expect(userData.data()!['bio'], newBio);
    });

    test(
        'should update user password successfully when no [Exception] '
        'is thrown', () async {
      when(
        () => mockUser.updatePassword(any()),
      ).thenAnswer((_) async => Future.value());

      when(
        () => mockUser.reauthenticateWithCredential(any()),
      ).thenAnswer((_) async => userCredential);

      when(
        () => mockUser.email,
      ).thenReturn(tEmail);

      await remoteDataSource.updateUser(
        action: UpdateUserAction.password,
        userData: jsonEncode(
          {
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          },
        ),
      );

      verify(
        () => mockUser.updatePassword(tPassword),
      );

      verifyNever(
        () => mockUser.updateDisplayName(any()),
      );
      verifyNever(
        () => mockUser.updatePhotoURL(any()),
      );
      verifyNever(
        () => mockUser.updateEmail(any()),
      );

      final userData = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();

      expect(userData.data()!['password'], null);
    });

    test(
        'should update useer profilPic successfully when no [Exception] '
        'is thrown', () async {
      final newProfilePic = File('assets/images/video_placeholder.png');

      when(
        () => mockUser.updatePhotoURL(any()),
      ).thenAnswer((_) async => Future.value());

      await remoteDataSource.updateUser(
        action: UpdateUserAction.profilePic,
        userData: newProfilePic,
      );

      verify(() => mockUser.updatePhotoURL(any())).called(1);

      verifyNever(
        () => mockUser.updateDisplayName(any()),
      );
      verifyNever(
        () => mockUser.updatePassword(any()),
      );
      verifyNever(
        () => mockUser.updateEmail(any()),
      );

      expect(dbClient.storedFilesMap.isNotEmpty, true);
    });
  });
}
