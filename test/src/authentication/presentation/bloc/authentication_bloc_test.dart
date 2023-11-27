import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:education_app/src/authentication/domain/usecases/sign_in.dart';
import 'package:education_app/src/authentication/domain/usecases/sign_up.dart';
import 'package:education_app/src/authentication/domain/usecases/update_user.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthenticationBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  final tServerFailure = APIFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifire. '
        'The user may have been deleted',
  );
  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();

    authBloc = AuthenticationBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(
    () {
      registerFallbackValue(tUpdateUserParams);
      registerFallbackValue(tSignInParams);
      registerFallbackValue(tSignUpParams);
    },
  );

  tearDown(() => authBloc.close());

  test('initialState should be [AuthenticationInitial]', () async {
    expect(authBloc.state, const AuthenticationInitial());
  });

  group('SignInEvent', () {
    const tUser = UserModel.empty();
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [AuthLoading, SignedIn] when [SignInEvent] is addedd',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => const <AuthenticationState>[AuthLoading(), SignedIn(tUser)],
      verify: (_) {
        verify(
          () => signIn(tSignInParams),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, AuthError] when signIn fails.',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignUpParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => <AuthenticationState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signIn(tSignInParams),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, SignedUp] when signUp event successfull.',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          fullName: tSignUpParams.fullName,
        ),
      ),
      expect: () => const <AuthenticationState>[AuthLoading(), SignedUp()],
      verify: (_) {
        verify(
          () => signUp(tSignUpParams),
        ).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, AuthError] when signUp fails.',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          fullName: tSignUpParams.fullName,
        ),
      ),
      expect: () => <AuthenticationState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signUp(tSignUpParams),
        ).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPassword Event', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, ForgotPasswordSent] when ForgotPasswordEvent '
      'is added and ForgotPassword success.',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => const Right(null));

        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => const <AuthenticationState>[
        AuthLoading(),
        ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(
          () => forgotPassword('email'),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, AuthError] when forgotPasswordEvent fails.',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent('email'),
      ),
      expect: () => <AuthenticationState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => forgotPassword('email'),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('Update User Data', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, UserUpdated] when UpdateUserEvent is added '
      'and UpdateUser success',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer(
          (_) async => const Right(null),
        );

        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          data: tUpdateUserParams.userData,
        ),
      ),
      expect: () => const <AuthenticationState>[AuthLoading(), UserUpdated()],
      verify: (_) {
        verify(
          () => updateUser(tUpdateUserParams),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emits [AuthLoading, AuthError] when updateUserEvent fails.',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          data: tUpdateUserParams.userData,
        ),
      ),
      expect: () => <AuthenticationState>[
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => updateUser(tUpdateUserParams),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
