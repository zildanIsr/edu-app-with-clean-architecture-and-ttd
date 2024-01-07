import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/notification/data/datasource/notification_remote_data_src.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/domain/entities/notification_entity.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:flutter/foundation.dart';

class NotificationRepoImpl implements NotificationRepo {
  const NotificationRepoImpl(this._remoteDataSrc);

  final NotificationRemoteDataSrc _remoteDataSrc;
  @override
  ResultFuture<void> clear(String notificationId) async {
    try {
      await _remoteDataSrc.clear(notificationId);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> clearAll() async {
    try {
      await _remoteDataSrc.clearAll();
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<Notification>> getNotifications() {
    return _remoteDataSrc.getNotifications().transform(
          StreamTransformer<List<NotificationModel>,
              Either<Failure, List<Notification>>>.fromHandlers(
            handleData: (notifications, sink) {
              sink.add(Right(notifications));
            },
            handleError: (error, stackTrace, sink) {
              debugPrint(stackTrace.toString());
              if (error is APIException) {
                sink.add(Left(APIFailure.fromException(error)));
              } else {
                sink.add(
                  Left(
                    APIFailure(message: error.toString(), statusCode: 505),
                  ),
                );
              }
            },
          ),
        );
  }

  @override
  ResultFuture<void> markAsRead(String notificationId) async {
    try {
      await _remoteDataSrc.markAsRead(notificationId);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sendNotification(Notification notification) async {
    try {
      await _remoteDataSrc.sendNotification(notification);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
