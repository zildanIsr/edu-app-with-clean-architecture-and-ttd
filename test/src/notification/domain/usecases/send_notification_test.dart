import 'package:dartz/dartz.dart';
import 'package:education_app/src/notification/domain/entities/notification_entity.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/send_notification.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_notification_repo.dart';

void main() {
  late NotificationRepo repo;
  late SendNotification usecase;
  final tNotification = Notification.empty();

  setUp(() {
    repo = MockNotificationRepo();
    usecase = SendNotification(repo);
    registerFallbackValue(tNotification);
  });

  test(
    'should call the [NotificationRepo.sendNotification]',
    () async {
      when(() => repo.sendNotification(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tNotification);

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.sendNotification(tNotification)).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
