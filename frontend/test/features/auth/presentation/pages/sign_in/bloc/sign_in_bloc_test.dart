import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/bloc/sign_in_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

const _passwordRequired = FieldError(
  field: 'password',
  code: 'required',
  message: 'is required',
);

const _emailInvalid = FieldError(
  field: 'email',
  code: 'invalid_format',
  message: 'invalid',
);

const _submitted = SignInEvent.submitted(email: 'a@b.co', password: 'pw');

void main() {
  late _MockLoginUseCase login;
  late SignInBloc bloc;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() {
    login = _MockLoginUseCase();
    bloc = SignInBloc(login);
  });

  tearDown(() => bloc.close());

  /// Types a form, submits it and returns the settled state.
  Future<SignInState> submit(Either<Failure, AuthSession> result) async {
    when(() => login(any())).thenAnswer((_) async => result);
    bloc.add(_submitted);
    await pumpEventQueue();
    return bloc.state;
  }

  test('sends the submitted form and stays busy on success', () async {
    // Arrange
    final result = Right<Failure, AuthSession>(authSession());

    // Act
    final state = await submit(result);

    // Assert
    verify(
      () => login(
        any(
          that: isA<LoginParams>()
              .having((p) => p.email, 'email', 'a@b.co')
              .having((p) => p.password, 'password', 'pw'),
        ),
      ),
    ).called(1);
    expect(state.status, UiStatus.success);
    expect(state.isSubmitting, isTrue);
  });

  test('field errors land on their fields and focus the first one', () async {
    // Arrange
    // Listed out of layout order, as the server may.
    const result = Left<Failure, AuthSession>(
      Failure.validation([_passwordRequired, _emailInvalid]),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.status, UiStatus.failure);
    expect(state.emailError, _emailInvalid);
    expect(state.passwordError, _passwordRequired);
    expect(state.focusField, AuthField.email);
    expect(state.formError, isNull);
  });

  test('a 422 for an unknown field shows the generic banner', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(
      Failure.validation([
        FieldError(field: 'other', code: 'required', message: 'x'),
      ]),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.formError, const AuthFormError.unexpected());
    expect(state.focusField, isNull);
  });

  test('wrong credentials show the banner', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(
      Failure.unauthorized(code: 'invalid_credentials'),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.status, UiStatus.failure);
    expect(state.formError, const AuthFormError.invalidCredentials());
    expect(state.isSubmitting, isFalse);
  });

  test('rate limiting rounds the wait up to whole minutes', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(
      Failure.tooManyRequests(retryAfter: Duration(seconds: 61)),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.formError, const AuthFormError.rateLimited(minutes: 2));
  });

  test('offline and timeouts show the network banner', () async {
    // Arrange
    const results = [
      Left<Failure, AuthSession>(Failure.network()),
      Left<Failure, AuthSession>(Failure.timeout()),
    ];

    // Act
    final states = <SignInState>[];
    for (final result in results) {
      states.add(await submit(result));
    }

    // Assert
    expect(
      states.map((s) => s.formError),
      everyElement(const AuthFormError.network()),
    );
  });

  test('editing a field clears its error and the banner', () async {
    // Arrange
    await submit(
      const Left(Failure.validation([_emailInvalid, _passwordRequired])),
    );

    // Act
    bloc.add(const SignInEvent.emailEdited());
    await pumpEventQueue();

    // Assert
    expect(bloc.state.emailError, isNull);
    expect(bloc.state.passwordError, _passwordRequired);
    expect(bloc.state.formError, isNull);
  });

  test('a second submit while signing in is ignored', () async {
    // Arrange
    final pending = Completer<Either<Failure, AuthSession>>();
    when(() => login(any())).thenAnswer((_) => pending.future);

    // Act
    bloc
      ..add(_submitted)
      ..add(_submitted);
    await pumpEventQueue();
    pending.complete(Right(authSession()));
    await pumpEventQueue();

    // Assert
    verify(() => login(any())).called(1);
  });
}
