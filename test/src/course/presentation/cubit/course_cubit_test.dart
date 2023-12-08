import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/usecase/add_course_use_case.dart';
import 'package:education_app/src/course/domain/usecase/get_course_use_case.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCourse extends Mock implements AddCourse {}

class MockGetCourse extends Mock implements GetCourse {}

void main() {
  late AddCourse addCourse;
  late GetCourse getCourse;
  late CourseCubit cubit;

  final tCourse = CourseModel.empty();

  final tFailure = APIFailure(
    message: 'something went error',
    statusCode: '500',
  );
  setUp(() {
    addCourse = MockAddCourse();
    getCourse = MockGetCourse();
    cubit = CourseCubit(
      addCourse: addCourse,
      getCourse: getCourse,
    );
    registerFallbackValue(tCourse);
  });

  tearDown(() => cubit.close());

  test('initial state should be [CourseInitial] ', () {
    expect(cubit.state, const CourseInitial());
  });

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseAdded] when addCourse is added.',
      build: () {
        when(
          () => addCourse(any()),
        ).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => const <CourseState>[
        AddingCourse(),
        CourseAdded(),
      ],
      verify: (_) {
        verify(
          () => addCourse(tCourse),
        ).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [AddingCourse, CourseError] when addCourse is added.',
      build: () {
        when(
          () => addCourse(any()),
        ).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.addCourse(tCourse),
      expect: () => <CourseState>[
        const AddingCourse(),
        CourseError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => addCourse(tCourse),
        ).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });

  group('getCourse', () {
    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourse, CourseLoaded] when getCourse is added.',
      build: () {
        when(
          () => getCourse(),
        ).thenAnswer(
          (_) async => Right([tCourse]),
        );
        return cubit;
      },
      act: (cubit) => cubit.getCourse(),
      expect: () => <CourseState>[
        const LoadingCourse(),
        CoursesLoaded([tCourse]),
      ],
      verify: (_) {
        verify(
          () => getCourse(),
        ).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'emits [LoadingCourse, CourseLoaded] when getCourses is added.',
      build: () {
        when(
          () => getCourse(),
        ).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.getCourse(),
      expect: () => <CourseState>[
        const LoadingCourse(),
        CourseError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => getCourse(),
        ).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });
}
