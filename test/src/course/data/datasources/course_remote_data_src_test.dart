import 'package:education_app/src/course/data/datasources/course_remote_data_src.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late CourseRemoteDataSrc remoteDataSrc;
  late FakeFirebaseFirestore firebaseFirestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  setUp(() async {
    firebaseFirestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    storage = MockFirebaseStorage();

    remoteDataSrc = CourseRemoteDataSrcImpl(
      firestore: firebaseFirestore,
      storage: storage,
      auth: auth,
    );
  });

  group('addCourse', () {
    test('should add the given course to the firestore collection', () async {
      final course = CourseModel.empty();

      await remoteDataSrc.addCourse(course);

      //Assert
      final firestoreData = await firebaseFirestore.collection('courses').get();
      expect(firestoreData.docs.length, 1);

      final courseRef = firestoreData.docs.first;
      expect(courseRef.data()['id'], courseRef.id);

      final groupData = await firebaseFirestore.collection('groups').get();
      expect(groupData.docs.length, 1);

      final groupRef = groupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);

      expect(courseRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['courseId'], courseRef.id);
    });
  });

  group('getCourse', () {
    test('should return a List<Course> when the call is successful', () async {
      final firstDate = DateTime.now();
      final secondDate = DateTime.now().add(const Duration(seconds: 20));

      final expectedCourse = [
        CourseModel.empty().copyWith(createdAt: firstDate),
        CourseModel.empty().copyWith(
          createdAt: secondDate,
          id: '1',
          title: 'Course 1',
        ),
      ];

      for (final course in expectedCourse) {
        await firebaseFirestore.collection('courses').add(course.toMap());
      }

      final result = await remoteDataSrc.getCourse();

      expect(result, expectedCourse);
    });
  });
}
