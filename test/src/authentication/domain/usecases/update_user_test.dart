import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/user_enums.dart';
import 'package:education_app/src/authentication/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUser useCase;

  setUp(
    () {
      repo = MockAuthRepo();
      useCase = UpdateUser(repo);
    },
  );

  // const tEmail = 'test email';
  // const tPassword = 'test password';
  const tFullName = 'test fullname';

  test('should call the [AuthRepository.UpdateUser]', () async {
    when(
      () => repo.updateUser(
        action: UpdateUserAction.userName,
        userData: tFullName,
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await useCase(
      const UpdateUserParams(
        action: UpdateUserAction.userName,
        userData: tFullName,
      ),
    );

    expect(result, const Right<dynamic, void>(null));

    verify(
      () => repo.updateUser(
        action: UpdateUserAction.userName,
        userData: tFullName,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
