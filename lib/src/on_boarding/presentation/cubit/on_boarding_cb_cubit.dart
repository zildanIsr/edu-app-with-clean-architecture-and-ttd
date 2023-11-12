import 'package:bloc/bloc.dart';
import 'package:education_app/src/on_boarding/domain/usecases/chace_first_time.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_cb_state.dart';

class OnBoardingCbCubit extends Cubit<OnBoardingCbState> {
  OnBoardingCbCubit({
    required CacheFirstTime cacheFirstTime,
    required CheckIfUserIsFirstTime checkIfUserIsFirstTime,
  })  : _cacheFirstTime = cacheFirstTime,
        _checkIfUserIsFirstTime = checkIfUserIsFirstTime,
        super(const OnBoardingCbInitial());

  final CacheFirstTime _cacheFirstTime;
  final CheckIfUserIsFirstTime _checkIfUserIsFirstTime;

  Future<void> cacheFirstTime() async {
    emit(const OnCachingFirstTime());
    final result = await _cacheFirstTime();

    result.fold(
      (failure) => emit(OnBoardingError(failure.errorMessage)),
      (_) => emit(const UserCached()),
    );
  }

  Future<void> checkIfUserFirstTime() async {
    emit(const OnCheckingIfUserIsFirstTime());
    final result = await _checkIfUserIsFirstTime();

    result.fold(
      (_) => emit(const OnBoardingStatus(isFirstTime: true)),
      (status) => emit(OnBoardingStatus(isFirstTime: status)),
    );
  }
}
