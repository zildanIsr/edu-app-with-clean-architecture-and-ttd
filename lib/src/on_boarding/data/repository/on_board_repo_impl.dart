import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_board_local_data_source.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';

class OnBoardRepoImpl extends OnBoardingRepo {
  const OnBoardRepoImpl(this._localDataSource);

  final OnBoardLocalDataSource _localDataSource;

  @override
  ResultFuture<void> cacheFirstTime() async {
    try {
      await _localDataSource.cacheFirstTime();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTime() async {
    try {
      final result = await _localDataSource.checkIfUserIsFirstTime();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
