import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/update_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late UpdateExam usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = UpdateExam(repo);
    registerFallbackValue(tExam);
  });

  test('should call [ExamRepo.UpdateExam] from the repo', () async {
    when(() => repo.updateExam(any())).thenAnswer(
      (_) async => const Right(null),
    );

    final result = await usecase(tExam);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.updateExam(tExam),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
