import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_board_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repository/on_board_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardLocalDataSource {}

void main() {
  late OnBoardLocalDataSource localDataSource;
  late OnBoardRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });

  group('cache first time', () {
    test(
        'should complete successfully when call to local source is '
        'successfully', () async {
      when(
        () => localDataSource.cacheFirstTime(),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.cacheFirstTime();

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => localDataSource.cacheFirstTime(),
      );

      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is '
        'unsuccessfully', () async {
      when(() => localDataSource.cacheFirstTime()).thenThrow(
        const CacheException(
          message: 'Insufficien storage',
        ),
      );

      final result = await repoImpl.cacheFirstTime();

      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(
              message: 'Insufficien storage',
              statusCode: 500,
            ),
          ),
        ),
      );

      verify(
        () => localDataSource.cacheFirstTime(),
      );
      verifyNoMoreInteractions(localDataSource);
    });
  });

  //group('check if user is first itme', () { });
}
