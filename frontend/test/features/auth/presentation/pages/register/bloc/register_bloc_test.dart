import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/register/bloc/register_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockRegisterUseCase extends Mock implements RegisterUseCase {}

const _nameRequired = FieldError(
  field: 'name',
  code: 'required',
  message: 'is required',
);

const _passwordTooShort = FieldError(
  field: 'password',
  code: 'min_length',
  message: 'too short',
  params: {'min': 8},
);

void main() {
  late _MockRegisterUseCase register;
  late RegisterBloc bloc;

  setUpAll(
    () => registerFallbackValue(
      const RegisterParams(name: '', email: '', password: ''),
    ),
  );

  setUp(() {
    register = _MockRegisterUseCase();
    bloc = RegisterBloc(register);
  });

  tearDown(() => bloc.close());

  Future<RegisterState> submit(Either<Failure, AuthSession> result) async {
    when(() => register(any())).thenAnswer((_) async => result);
    bloc.add(
      const RegisterEvent.submitted(
        name: 'Ana',
        email: 'a@b.co',
        password: 'password1',
      ),
    );
    await pumpEventQueue();
    return bloc.state;
  }

  test('the password hint follows the minimum length', () async {
    // Arrange
    final states = <bool>[];
    final sub = bloc.stream.listen((s) => states.add(s.passwordLongEnough));

    // Act
    bloc
      ..add(const RegisterEvent.passwordEdited('1234567'))
      ..add(const RegisterEvent.passwordEdited('12345678'));
    await pumpEventQueue();
    await sub.cancel();

    // Assert
    expect(states, [false, true]);
  });

  test('sends the submitted form and stays busy on success', () async {
    // Arrange
    final result = Right<Failure, AuthSession>(authSession());

    // Act
    final state = await submit(result);

    // Assert
    verify(
      () => register(
        any(
          that: isA<RegisterParams>()
              .having((p) => p.name, 'name', 'Ana')
              .having((p) => p.email, 'email', 'a@b.co')
              .having((p) => p.password, 'password', 'password1'),
        ),
      ),
    ).called(1);
    expect(state.status, UiStatus.success);
    expect(state.status.isSubmitting, isTrue);
  });

  test('field errors focus the first field in layout order', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(
      Failure.validation([_passwordTooShort, _nameRequired]),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.nameError, _nameRequired);
    expect(state.passwordError, _passwordTooShort);
    expect(state.focusField, AuthField.name);
  });

  test('a taken email marks the email field, not the banner', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(
      Failure.conflict(code: 'conflict'),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.status, UiStatus.failure);
    expect(state.emailTaken, isTrue);
    expect(state.focusField, AuthField.email);
    expect(state.formError, isNull);
  });

  test('editing the email clears the taken mark', () async {
    // Arrange
    await submit(const Left(Failure.conflict()));

    // Act
    bloc.add(const RegisterEvent.emailEdited('b@c.co'));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.emailTaken, isFalse);
    expect(bloc.state.emailError, isNull);
  });

  test('editing before a failed submit shows no field errors', () async {
    // Arrange
    // (a fresh form)

    // Act
    bloc
      ..add(const RegisterEvent.nameEdited(' '))
      ..add(const RegisterEvent.passwordEdited('short'));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.nameError, isNull);
    expect(bloc.state.passwordError, isNull);
  });

  test('after a failed submit, an edit re-checks only its field', () async {
    // Arrange
    await submit(
      const Left(Failure.validation([_nameRequired, _passwordTooShort])),
    );

    // Act
    bloc.add(const RegisterEvent.passwordEdited('password1'));
    await pumpEventQueue();
    final fixed = bloc.state;
    bloc.add(const RegisterEvent.nameEdited('  '));
    await pumpEventQueue();

    // Assert
    expect(fixed.passwordError, isNull);
    expect(fixed.nameError, _nameRequired);
    expect(bloc.state.nameError?.code, 'required');
  });

  test('a server error shows the generic banner', () async {
    // Arrange
    const result = Left<Failure, AuthSession>(Failure.server(500));

    // Act
    final state = await submit(result);

    // Assert
    expect(state.formError, const AuthFormError.unexpected());
    expect(state.status.isSubmitting, isFalse);
  });
}
