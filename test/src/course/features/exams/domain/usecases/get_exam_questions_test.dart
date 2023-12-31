import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetExamsQuestions usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExamsQuestions(repo);
    registerFallbackValue(tExam);
  });

  test('should call [ExamRepo.getExamQuestions]', () async {
    when(() => repo.getExamQuestions(any())).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await usecase(tExam);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.getExamQuestions(tExam),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
