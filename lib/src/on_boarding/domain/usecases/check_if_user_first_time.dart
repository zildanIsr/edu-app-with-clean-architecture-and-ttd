import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';

class CheckIfUserIsFirstTime extends UsecaseWithoutParams<bool> {
  const CheckIfUserIsFirstTime(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<bool> call() async => _repo.checkIfUserIsFirstTime();
}
