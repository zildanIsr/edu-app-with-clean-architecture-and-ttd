import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPassword useCase;

  setUp(
    () {
      repo = MockAuthRepo();
      useCase = ForgotPassword(repo);
    },
  );

  const tEmail = 'test email';

  test('should call the [AuthRepository.forgetPasswoord]', () async {
    when(
      () => repo.forgotPassword(tEmail),
    ).thenAnswer((_) async => const Right(null));

    final result = await useCase(tEmail);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.forgotPassword(tEmail),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
