import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/data/datasources/course_remote_data_src.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/data/repos/course_repo_impl.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDataSrc extends Mock implements CourseRemoteDataSrc {}

void main() {
  late CourseRemoteDataSrc remoteDataSrc;
  late CourseRepoImpl repoImpl;

  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDataSrc = MockCourseRemoteDataSrc();
    repoImpl = CourseRepoImpl(remoteDataSrc);
    registerFallbackValue(tCourse);
  });

  final tException = APIException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addCourse', () {
    test(
        'should complete successfully when call to remote source is successful',
        () async {
      when(
        () => remoteDataSrc.addCourse(any()),
      ).thenAnswer((_) async => Future.value);

      final result = await repoImpl.addCourse(tCourse);

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => remoteDataSrc.addCourse(tCourse),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return [APIException] when call to remote source is '
        'unsuccessful.', () async {
      when(
        () => remoteDataSrc.addCourse(any()),
      ).thenThrow(tException);

      final result = await repoImpl.addCourse(tCourse);

      expect(result, Left<Failure, void>(APIFailure.fromException(tException)));

      verify(
        () => remoteDataSrc.addCourse(tCourse),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getCourses', () {
    test(
        'should complete successfully when call to remote source is successful',
        () async {
      when(
        () => remoteDataSrc.getCourse(),
      ).thenAnswer((_) async => []);

      final result = await repoImpl.getCourse();

      expect(result, isA<Right<dynamic, List<Course>>>());

      verify(
        () => remoteDataSrc.getCourse(),
      ).called(1);

      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return [APIException] when call to remote source is '
        'unsuccessful.', () async {
      when(
        () => remoteDataSrc.getCourse(),
      ).thenThrow(tException);

      final result = await repoImpl.getCourse();

      expect(result, Left<Failure, void>(APIFailure.fromException(tException)));

      verify(
        () => remoteDataSrc.getCourse(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
