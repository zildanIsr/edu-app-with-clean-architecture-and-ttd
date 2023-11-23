import 'package:education_app/core/errors/exception.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
      : assert(
          statusCode is String || statusCode is int,
          'StatusCode cannot be a ${statusCode.runtimeType}',
        );

  final String message;
  final dynamic statusCode;

  String get errorMessage =>
      '$statusCode, ${statusCode is String ? '' : 'Error'} : $message';

  @override
  List<dynamic> get props => [message, statusCode];
}

class APIFailure extends Failure {
  APIFailure({required super.message, required super.statusCode});

  factory APIFailure.fromException(APIException exception) =>
      APIFailure(message: exception.message, statusCode: exception.statusCode);
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}
