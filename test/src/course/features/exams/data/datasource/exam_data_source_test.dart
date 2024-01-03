import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/features/exams/data/datasource/exam_data_source.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_question_model.dart';
import 'package:education_app/src/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late ExamRemoteDataSrc remoteDataSrc;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  //late MockFirebaseStorage storage;

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

    //storage = MockFirebaseStorage();

    remoteDataSrc = ExamRemoteDataSrcImpl(
      auth: auth,
      firestore: firestore,
    );
  });

  group('uploadExam', () {
    test(
        'should upload the given [Exam] to the firestore and seprate the '
        '[Exam] and the [Exam.question]', () async {
      final exam = const ExamModel.empty().copyWith(
        questions: [const ExamQuestionModel.empty()],
      );

      await firestore
          .collection('courses')
          .doc(exam.courseId)
          .set(CourseModel.empty().copyWith(id: exam.courseId).toMap());

      //Act
      await remoteDataSrc.uploadExam(exam);

      //Assert
      final examDocs = await firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .get();

      expect(examDocs.docs, isNotEmpty);

      final examModel = ExamModel.fromMap(examDocs.docs.first.data());
      expect(examModel.courseId, exam.courseId);

      //check for questions exam
      final questionDocs = await firestore
          .collection('courses')
          .doc(examModel.courseId)
          .collection('exams')
          .doc(examModel.id)
          .collection('questions')
          .get();

      expect(questionDocs.docs, isNotEmpty);
      final questionModel =
          ExamQuestionModel.fromMap(questionDocs.docs.first.data());
      expect(questionModel.courseId, exam.courseId);
      expect(questionModel.examId, examModel.id);
    });
  });

  group('getExamQuestions', () {
    test('should return the questions of the given exam', () async {
      final exam = const ExamModel.empty().copyWith(
        questions: [const ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId).set(
            CourseModel.empty().copyWith(id: exam.courseId).toMap(),
          );

      //add dummy
      await remoteDataSrc.uploadExam(exam);

      //act
      final examCollection = await firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .get();

      final examModel = ExamModel.fromMap(examCollection.docs.first.data());

      //act
      final result = await remoteDataSrc.getExamQuestions(examModel);

      expect(result, isA<List<ExamQuestionModel>>());
      expect(result, hasLength(1));
      expect(result.first.courseId, exam.courseId);
    });
  });

  group('getExams', () {
    test('should return the exams of the given course', () async {
      final exam = const ExamModel.empty().copyWith(
        questions: [const ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId).set(
            CourseModel.empty().copyWith(id: exam.courseId).toMap(),
          );

      await remoteDataSrc.uploadExam(exam);

      final result = await remoteDataSrc.getExams(exam.courseId);

      expect(result, isA<List<ExamModel>>());
      expect(result, hasLength(1));
      expect(result.first.courseId, exam.courseId);
    });
  });

  group('updateExam', () {
    test('should update the given exam', () async {
      final exam = const ExamModel.empty().copyWith(
        questions: [const ExamQuestionModel.empty()],
      );

      await firestore.collection('courses').doc(exam.courseId).set(
            CourseModel.empty().copyWith(id: exam.courseId).toMap(),
          );

      await remoteDataSrc.uploadExam(exam);

      final examsCollection = await firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .get();

      final examModel = ExamModel.fromMap(examsCollection.docs.first.data());
      await remoteDataSrc.updateExam(examModel.copyWith(timeLimit: 100));

      //assert
      final updateExam = await firestore
          .collection('courses')
          .doc(exam.courseId)
          .collection('exams')
          .doc(examModel.id)
          .get();
      expect(updateExam.data(), isNotEmpty);

      final updateExamModel = ExamModel.fromMap(updateExam.data()!);
      expect(updateExamModel.courseId, exam.courseId);
      expect(updateExamModel.timeLimit, 100);
    });
  });

  group('submitExam', () {
    test(
      'should submit the given exam',
      () async {
        // Arrange
        final userExam = UserExamModel.empty().copyWith(
          totalQuestions: 2,
          answers: [const UserChoiceModel.empty()],
        );
        await firestore.collection('users').doc(auth.currentUser!.uid).set(
              const UserModel.empty()
                  .copyWith(uid: auth.currentUser!.uid, points: 1)
                  .toMap(),
            );
        // Act
        await remoteDataSrc.submitExam(userExam);

        // Assert
        final submittedExam = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('courses')
            .doc(userExam.courseId)
            .collection('exams')
            .doc(userExam.examId)
            .get();

        expect(submittedExam.data(), isNotEmpty);
        final submittedExamModel = UserExamModel.fromMap(submittedExam.data()!);
        expect(submittedExamModel.courseId, userExam.courseId);

        final userDoc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();

        expect(userDoc.data(), isNotEmpty);
        final userModel = UserModel.fromMap(userDoc.data()!);
        expect(userModel.points, 51);

        expect(userModel.enrolledCourseIds, contains(userExam.courseId));
      },
    );
  });

  group('getUserCourseExams', () {
    test('should return the exams of the given course', () async {
      //Arrange
      final exam = UserExamModel.empty();

      await firestore.collection('users').doc(auth.currentUser!.uid).set(
            const UserModel.empty()
                .copyWith(uid: auth.currentUser!.uid, points: 1)
                .toMap(),
          );

      await remoteDataSrc.submitExam(exam);

      //Act
      final result = await remoteDataSrc.getUserCourseExams(exam.courseId);

      //Assert
      expect(result, isA<List<UserExamModel>>());
      expect(result, hasLength(1));
      expect(result.first.courseId, exam.courseId);
    });
  });

  group('getUserExams', () {
    test('should return the exams of the current user', () async {
      final exam = UserExamModel.empty();

      await firestore.collection('users').doc(auth.currentUser!.uid).set(
            const UserModel.empty()
                .copyWith(uid: auth.currentUser!.uid, points: 1)
                .toMap(),
          );

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('courses')
          .doc(exam.courseId)
          .set(CourseModel.empty().copyWith(id: exam.courseId).toMap());

      await remoteDataSrc.submitExam(exam);

      final result = await remoteDataSrc.getUserExams();

      expect(result, isA<List<UserExamModel>>());
      expect(result, hasLength(1));
      expect(result.first.courseId, exam.courseId);
    });
  });
}
