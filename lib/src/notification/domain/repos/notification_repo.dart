import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepo {
  const NotificationRepo();

  ResultFuture<void> markAsRead(String notificationId);

  ResultFuture<void> clearAll();

  ResultFuture<void> clear(String notificationId);

  ResultFuture<void> sendNotification(Notification notification);

  ResultStream<List<Notification>> getNotifications();
}
