import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/usecases/chace_first_time.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cb_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTime extends Mock implements CacheFirstTime {}

class MockCheckIfUserIsFirstTIme extends Mock
    implements CheckIfUserIsFirstTime {}

void main() {
  late CacheFirstTime cacheFirstTime;
  late CheckIfUserIsFirstTime checkIfUserIsFirstTime;
  late OnBoardingCbCubit onBoardingCbCubit;

  setUp(() {
    cacheFirstTime = MockCacheFirstTime();
    checkIfUserIsFirstTime = MockCheckIfUserIsFirstTIme();
    onBoardingCbCubit = OnBoardingCbCubit(
      cacheFirstTime: cacheFirstTime,
      checkIfUserIsFirstTime: checkIfUserIsFirstTime,
    );
  });

  final tFailure = CacheFailure(
    message: 'Insufficient Permissions',
    statusCode: 4032,
  );

  test('initial state should be [OnBoardingCbInitial] ', () {
    expect(onBoardingCbCubit.state, const OnBoardingCbInitial());
  });

  group('chache first time', () {
    blocTest<OnBoardingCbCubit, OnBoardingCbState>(
      'should emit [CachingFirstTIme, UserCached] when successful',
      build: () {
        when(
          () => cacheFirstTime(),
        ).thenAnswer(
          (_) async => const Right(null),
        );

        return onBoardingCbCubit;
      },
      act: (cubit) => cubit.cacheFirstTime(),
      expect: () => const [OnCachingFirstTime(), UserCached()],
      verify: (_) {
        verify(
          () => cacheFirstTime(),
        ).called(1);
        verifyNoMoreInteractions(cacheFirstTime);
      },
    );

    blocTest<OnBoardingCbCubit, OnBoardingCbState>(
      'should emit [CachingFirstTime, OnBoardingError] when unsuccessful',
      build: () {
        when(() => cacheFirstTime()).thenAnswer(
          (_) async => Left(tFailure),
        );

        return onBoardingCbCubit;
      },
      act: (cubit) => cubit.cacheFirstTime(),
      expect: () => [
        const OnCachingFirstTime(),
        OnBoardingError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => cacheFirstTime(),
        ).called(1);
        verifyNoMoreInteractions(cacheFirstTime);
      },
    );
  });

  group('Check if user is the first time', () {
    blocTest<OnBoardingCbCubit, OnBoardingCbState>(
      'should emit [OnCheckingIfUserIsFirstTime, OnBoardingStatus] '
      'when successful',
      build: () {
        when(
          () => checkIfUserIsFirstTime(),
        ).thenAnswer(
          (_) async => const Right(false),
        );

        return onBoardingCbCubit;
      },
      act: (cubit) => cubit.checkIfUserFirstTime(),
      expect: () => const [
        OnCheckingIfUserIsFirstTime(),
        OnBoardingStatus(isFirstTime: false)
      ],
      verify: (_) {
        verify(
          () => checkIfUserIsFirstTime(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTime);
      },
    );

    blocTest<OnBoardingCbCubit, OnBoardingCbState>(
      'should emit [CheckingIfUserIsFirstTime, OnBoardingStatus] '
      'when unsuccessful',
      build: () {
        when(
          () => checkIfUserIsFirstTime(),
        ).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );

        return onBoardingCbCubit;
      },
      act: (cubit) => cubit.checkIfUserFirstTime(),
      expect: () => const [
        OnCheckingIfUserIsFirstTime(),
        OnBoardingStatus(isFirstTime: true)
      ],
      verify: (_) {
        verify(
          () => checkIfUserIsFirstTime(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTime);
      },
    );
  });
}
