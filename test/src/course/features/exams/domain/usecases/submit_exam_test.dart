import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late SubmitExam usecase;

  final tUserExam = UserExam.empty(DateTime.now());

  setUp(() {
    repo = MockExamRepo();
    usecase = SubmitExam(repo);
    registerFallbackValue(tUserExam);
  });

  test('should return [List<UserExam] from the repo', () async {
    when(() => repo.submitExam(any())).thenAnswer(
      (_) async => const Right(null),
    );

    final result = await usecase(tUserExam);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.submitExam(tUserExam),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
