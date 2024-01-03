import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/features/exams/data/datasource/exam_data_source.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:education_app/src/course/features/exams/data/repos/exam_repo_impl.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamRemoteDataSrc extends Mock implements ExamRemoteDataSrc {}

void main() {
  late MockExamRemoteDataSrc remoteDataSrc;
  late ExamRepoImpl repo;

  const tExam = ExamModel.empty();
  final tuserExam = UserExamModel.empty();

  setUp(() {
    remoteDataSrc = MockExamRemoteDataSrc();
    repo = ExamRepoImpl(remoteDataSrc);
    registerFallbackValue(tExam);
    registerFallbackValue(tuserExam);
  });

  final tException = APIException(
    message: 'Test message',
    statusCode: '500',
  );

  group('getExamQuestions', () {
    test(
        'should return [List<ExamQuestion>] when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.getExamQuestions(any()),
      ).thenAnswer((_) async => []);

      final result = await repo.getExamQuestions(tExam);

      expect(result, isA<Right<dynamic, List<ExamQuestion>>>());

      verify(
        () => remoteDataSrc.getExamQuestions(tExam),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.getExamQuestions(any()),
      ).thenThrow(tException);

      final result = await repo.getExamQuestions(tExam);

      expect(
        result,
        equals(
          Left<APIFailure, List<ExamQuestion>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('getExams', () {
    test(
        'should return [List<Exam>] when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.getExams(any()),
      ).thenAnswer((_) async => []);

      final result = await repo.getExams(tExam.courseId);

      expect(result, isA<Right<dynamic, List<Exam>>>());

      verify(
        () => remoteDataSrc.getExams(tExam.courseId),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.getExams(any()),
      ).thenThrow(tException);

      final result = await repo.getExams(tExam.courseId);

      expect(
        result,
        equals(
          Left<APIFailure, List<Exam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('getUserCourseExams', () {
    test(
        'should return [List<UserExam>] when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.getUserCourseExams(any()),
      ).thenAnswer((_) async => []);

      final result = await repo.getUserCourseExams(tExam.courseId);

      expect(result, isA<Right<dynamic, List<UserExam>>>());

      verify(
        () => remoteDataSrc.getUserCourseExams(tExam.courseId),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.getUserCourseExams(any()),
      ).thenThrow(tException);

      final result = await repo.getUserCourseExams(tExam.courseId);

      expect(
        result,
        equals(
          Left<APIFailure, List<UserExam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('getUserExams', () {
    test(
        'should return [List<UserExam>] when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.getUserExams(),
      ).thenAnswer((_) async => []);

      final result = await repo.getUserExams();

      expect(result, isA<Right<dynamic, List<UserExam>>>());

      verify(
        () => remoteDataSrc.getUserExams(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.getUserExams(),
      ).thenThrow(tException);

      final result = await repo.getUserExams();

      expect(
        result,
        equals(
          Left<APIFailure, List<UserExam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('submitExam', () {
    test(
        'should return successfully when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.submitExam(tuserExam),
      ).thenAnswer((_) async => []);

      final result = await repo.submitExam(tuserExam);

      expect(result, isA<Right<dynamic, void>>());

      verify(
        () => remoteDataSrc.submitExam(tuserExam),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.submitExam(tuserExam),
      ).thenThrow(tException);

      final result = await repo.submitExam(tuserExam);

      expect(
        result,
        equals(
          Left<APIFailure, List<UserExam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('updateExam', () {
    test(
        'should return successfully when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.updateExam(tExam),
      ).thenAnswer((_) async => []);

      final result = await repo.updateExam(tExam);

      expect(result, isA<Right<dynamic, void>>());

      verify(
        () => remoteDataSrc.updateExam(tExam),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.updateExam(tExam),
      ).thenThrow(tException);

      final result = await repo.updateExam(tExam);

      expect(
        result,
        equals(
          Left<APIFailure, List<UserExam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });

  group('uploadExam', () {
    test(
        'should return successfully when call to remote source is '
        'successful', () async {
      when(
        () => remoteDataSrc.uploadExam(tExam),
      ).thenAnswer((_) async => []);

      final result = await repo.uploadExam(tExam);

      expect(result, isA<Right<dynamic, void>>());

      verify(
        () => remoteDataSrc.uploadExam(tExam),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return APIFailure when call to remote source is '
        'unsuccessful', () async {
      when(
        () => remoteDataSrc.uploadExam(tExam),
      ).thenThrow(tException);

      final result = await repo.uploadExam(tExam);

      expect(
        result,
        equals(
          Left<APIFailure, List<UserExam>>(
            APIFailure.fromException(tException),
          ),
        ),
      );
    });
  });
}
