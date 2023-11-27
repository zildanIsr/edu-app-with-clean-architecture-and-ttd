part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthenticationEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

class SignUpEvent extends AuthenticationEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  final String email;
  final String password;
  final String fullName;

  @override
  List<String> get props => [email, password, fullName];
}

class ForgotPasswordEvent extends AuthenticationEvent {
  const ForgotPasswordEvent(this.email);

  final String email;

  @override
  List<String> get props => [email];
}

class UpdateUserEvent extends AuthenticationEvent {
  UpdateUserEvent({
    required this.action,
    required this.data,
  }) : assert(
          data is String || data is File,
          '[data] must be either a String or a File, '
          'but was ${data.runtimeType}',
        );

  final UpdateUserAction action;
  final dynamic data;

  @override
  List<Object?> get props => [action, data];
}
