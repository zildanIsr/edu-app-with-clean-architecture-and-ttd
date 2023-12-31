import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetUserCourseExams usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserCourseExams(repo);
    registerFallbackValue(tExam);
  });

  test('should return [List<UserExam] from the repo', () async {
    when(() => repo.getUserCourseExams(any())).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await usecase(tExam.courseId);

    expect(result, isA<Right<dynamic, List<UserExam>>>());
    verify(
      () => repo.getUserCourseExams(tExam.courseId),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
