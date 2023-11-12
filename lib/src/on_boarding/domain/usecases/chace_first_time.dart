import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';

class CacheFirstTime extends UsecaseWithoutParams<void> {
  const CacheFirstTime(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<void> call() async => _repo.cacheFirstTime();
}
