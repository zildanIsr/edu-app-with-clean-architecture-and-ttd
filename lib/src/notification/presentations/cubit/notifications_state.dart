part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

class ClearingNotifications extends NotificationsState {
  const ClearingNotifications();
}

class NotificationCleared extends NotificationsState {
  const NotificationCleared();
}

class SendingNotification extends NotificationsState {
  const SendingNotification();
}

class NotificationSent extends NotificationsState {
  const NotificationSent();
}

class GettingNotifications extends NotificationsState {
  const GettingNotifications();
}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded(this.notifications);

  final List<Notification> notifications;

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationsState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
