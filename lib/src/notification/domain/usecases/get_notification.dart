import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/notification/domain/entities/notification_entity.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';

class GetNotifications extends StreamUsecaseWithoutParams<List<Notification>> {
  const GetNotifications(this._repo);

  final NotificationRepo _repo;

  @override
  ResultStream<List<Notification>> call() => _repo.getNotifications();
}
