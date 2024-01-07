import 'package:dartz/dartz.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_notification_repo.dart';

void main() {
  late NotificationRepo repo;
  late MarkAsRead usecase;

  setUp(() {
    repo = MockNotificationRepo();
    usecase = MarkAsRead(repo);
  });

  test(
    'should call the [NotificationRepo.markAsRead]',
    () async {
      when(() => repo.markAsRead(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase('id');

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.markAsRead('id')).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
