import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_exam.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late MockExamRepo repo;
  late GetUserExams usecase;

  const tExam = Exam.empty();

  setUp(() {
    repo = MockExamRepo();
    usecase = GetUserExams(repo);
    registerFallbackValue(tExam);
  });

  test('should return [List<UserExam] from the repo', () async {
    when(() => repo.getUserExams()).thenAnswer(
      (_) async => const Right([]),
    );

    final result = await usecase();

    expect(result, isA<Right<dynamic, List<UserExam>>>());
    verify(
      () => repo.getUserExams(),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
