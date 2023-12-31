import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/upload_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late UploadExam usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = UploadExam(repo);
    registerFallbackValue(tExam);
  });

  test('should call [ExamRepo.UploadExam] from the repo', () async {
    when(() => repo.uploadExam(any())).thenAnswer(
      (_) async => const Right(null),
    );

    final result = await usecase(tExam);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.uploadExam(tExam),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
