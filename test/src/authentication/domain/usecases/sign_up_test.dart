import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp useCase;

  setUp(
    () {
      repo = MockAuthRepo();
      useCase = SignUp(repo);
    },
  );

  const tEmail = 'test email';
  const tPassword = 'test password';
  const tFullName = 'test fullname';

  test('should call the [AuthRepository.SignUp]', () async {
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await useCase(
      const SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    expect(result, const Right<dynamic, void>(null));

    verify(
      () => repo.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    verifyNoMoreInteractions(repo);
  });
}
