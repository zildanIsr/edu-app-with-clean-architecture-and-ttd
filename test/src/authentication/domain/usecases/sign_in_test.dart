import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/entities/user.dart';
import 'package:education_app/src/authentication/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignIn useCase;

  setUp(
    () {
      repo = MockAuthRepo();
      useCase = SignIn(repo);
    },
  );

  const tEmail = 'test email';
  const tPassword = 'test password';

  const tUser = LocalUser.empty();

  test('should call the [AuthRepository.SignIn] and return user data',
      () async {
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await useCase(
      const SignInParams(
        email: tEmail,
        password: tPassword,
      ),
    );

    expect(result, const Right<dynamic, LocalUser>(tUser));

    verify(
      () => repo.signIn(email: tEmail, password: tPassword),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
