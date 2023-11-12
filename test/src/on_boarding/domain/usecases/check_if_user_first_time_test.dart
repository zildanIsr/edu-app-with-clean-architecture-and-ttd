import 'package:dartz/dartz.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTime usecase;

  setUp(() {
    repo = OnBoardingRepoMock();
    usecase = CheckIfUserIsFirstTime(repo);
  });

  test(
      'should call the [onBoardingRepo.CheckIfUserIsFirstTime] '
      'and return the right data]', () async {
    when(() => repo.checkIfUserIsFirstTime()).thenAnswer(
      (_) async => const Right(
        true,
      ),
    );

    final result = await usecase();

    expect(
      result,
      equals(
        const Right<dynamic, bool>(
          true,
        ),
      ),
    );

    verify(() => repo.checkIfUserIsFirstTime()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
