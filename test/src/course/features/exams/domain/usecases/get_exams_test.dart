import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetExams usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExams(repo);
    registerFallbackValue(tExam);
  });

  test('should call [ExamRepo.getExamQuestions]', () async {
    when(() => repo.getExams(any())).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await usecase(tExam.courseId);

    expect(result, isA<Right<dynamic, List<Exam>>>());
    verify(
      () => repo.getExams(tExam.courseId),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
