import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/chace_first_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTime usecase;

  setUp(() {
    repo = OnBoardingRepoMock();
    usecase = CacheFirstTime(repo);
  });

  test(
      'should call the [onBoardingRepo.cacheFirstTime] '
      'and return the right data]', () async {
    when(() => repo.cacheFirstTime()).thenAnswer(
      (_) async => Left(
        APIFailure(
          message: 'Unknown Error Occurred',
          statusCode: 500,
        ),
      ),
    );

    final result = await usecase();

    expect(
      result,
      equals(
        Left<Failure, dynamic>(
          APIFailure(
            message: 'Unknown Error Occurred',
            statusCode: 500,
          ),
        ),
      ),
    );

    verify(() => repo.cacheFirstTime()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
