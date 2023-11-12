part of 'on_boarding_cb_cubit.dart';

sealed class OnBoardingCbState extends Equatable {
  const OnBoardingCbState();

  @override
  List<Object> get props => [];
}

class OnBoardingCbInitial extends OnBoardingCbState {
  const OnBoardingCbInitial();
}

class OnCachingFirstTime extends OnBoardingCbState {
  const OnCachingFirstTime();
}

class OnCheckingIfUserIsFirstTime extends OnBoardingCbState {
  const OnCheckingIfUserIsFirstTime();
}

class UserCached extends OnBoardingCbState {
  const UserCached();
}

class OnBoardingStatus extends OnBoardingCbState {
  const OnBoardingStatus({required this.isFirstTime});

  final bool isFirstTime;

  @override
  List<bool> get props => [isFirstTime];
}

class OnBoardingError extends OnBoardingCbState {
  const OnBoardingError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
