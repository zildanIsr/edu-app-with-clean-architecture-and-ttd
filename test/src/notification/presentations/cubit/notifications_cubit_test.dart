import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/domain/usecases/clear.dart';
import 'package:education_app/src/notification/domain/usecases/clear_all.dart';
import 'package:education_app/src/notification/domain/usecases/get_notification.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read.dart';
import 'package:education_app/src/notification/domain/usecases/send_notification.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClear extends Mock implements Clear {}

class MockClearAll extends Mock implements ClearAll {}

class MockGetNotifications extends Mock implements GetNotifications {}

class MockMarkAsRead extends Mock implements MarkAsRead {}

class MockSendNotification extends Mock implements SendNotification {}

void main() {
  late NotificationsCubit cubit;
  late Clear clear;
  late ClearAll clearAll;
  late GetNotifications getNotifications;
  late MarkAsRead markAsRead;
  late SendNotification sendNotification;

  setUp(() {
    clear = MockClear();
    clearAll = MockClearAll();
    getNotifications = MockGetNotifications();
    markAsRead = MockMarkAsRead();
    sendNotification = MockSendNotification();
    cubit = NotificationsCubit(
      clear: clear,
      clearAll: clearAll,
      getNotifications: getNotifications,
      markAsRead: markAsRead,
      sendNotification: sendNotification,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is NotificationInitial', () {
    expect(cubit.state, NotificationsInitial());
  });

  final tFailure = APIFailure(message: 'Server Error', statusCode: 500);

  group('clear', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[ClearingNotifications, NotificationCleared] when successful',
      build: () {
        when(() => clear(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => [
        const ClearingNotifications(),
        const NotificationCleared(),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(() => clear(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => [
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );
  });

  group('clearAll', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[ClearingNotifications, NotificationCleared] when successful',
      build: () {
        when(() => clearAll()).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const ClearingNotifications(),
        const NotificationCleared(),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(() => clearAll()).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );
  });

  group('markAsRead', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[NotificationInitial] when successful',
      build: () {
        when(() => markAsRead(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => [NotificationsInitial()],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[NotificationError] when unsuccessful',
      build: () {
        when(() => markAsRead(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => [NotificationError(tFailure.errorMessage)],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );
  });

  group('sendNotification', () {
    final tNotification = NotificationModel.empty();
    setUp(() => registerFallbackValue(tNotification));

    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[SendingNotification, NotificationSent] when successful',
      build: () {
        when(() => sendNotification(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => [
        const SendingNotification(),
        const NotificationSent(),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[SendingNotification, NotificationError] when unsuccessful',
      build: () {
        when(() => sendNotification(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => [
        const SendingNotification(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );
  });

  // group('getNotifications', () {
  //   final tNotification = NotificationModel.empty();
  //   test(
  //     'should return [Stream<Either<NotificationError, '
  //  'List<Notification>>>] '
  //         'when successful',
  //         () async {
  //       when(() => getNotifications())
  //           .thenAnswer((_) => Stream.value(Right([tNotification])));
  //
  //       final result = cubit.getNotifications();
  //
  //       expect(
  //         result,
  //         isA<Stream<Either<NotificationError, List<Notification>>>>(),
  //       );
  //
  //       verify(() => getNotifications()).called(1);
  //       verifyNoMoreInteractions(getNotifications);
  //     },
  //   );
  //
  //   test(
  //     'should return [Stream<Either<NotificationError, '
  //    'List<Notification>>>] '
  //         'when unsuccessful',
  //         () async {
  //       when(() => getNotifications()).thenAnswer(
  //             (_) => Stream.value(
  //           Left(
  //             APIFailure(message: 'Server Error', statusCode: 500),
  //           ),
  //         ),
  //       );
  //
  //       final result = cubit.getNotifications();
  //
  //       expect(
  //         result,
  //         isA<Stream<Either<NotificationError, List<Notification>>>>(),
  //       );
  //
  //       verify(() => getNotifications()).called(1);
  //       verifyNoMoreInteractions(getNotifications);
  //     },
  //   );
  // });

  group('getNotifications', () {
    final tNotifications = [NotificationModel.empty()];
    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[GettingNotifications, NotificationsLoaded] when successful',
      build: () {
        when(() => getNotifications()).thenAnswer(
          (_) => Stream.value(Right(tNotifications)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        const GettingNotifications(),
        NotificationsLoaded(tNotifications),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
    blocTest<NotificationsCubit, NotificationsState>(
      'should emit '
      '[GettingNotifications, NotificationError] when successful',
      build: () {
        when(() => getNotifications()).thenAnswer(
          (_) => Stream.value(Left(tFailure)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        const GettingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
  });
}
