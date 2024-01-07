import 'package:dartz/dartz.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/get_notification.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_notification_repo.dart';

void main() {
  late NotificationRepo repo;
  late GetNotifications usecase;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = GetNotifications(repo);
  });

  test(
    'should return a [Stream<List<Notification>>] from the [NotificationRepo]',
    () async {
      when(() => repo.getNotifications())
          .thenAnswer((_) => Stream.value(const Right([])));

      final result = usecase();

      expect(result, emits(const Right<dynamic, List<Notification>>([])));

      verify(() => repo.getNotifications()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
