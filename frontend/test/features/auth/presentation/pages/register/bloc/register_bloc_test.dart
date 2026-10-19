import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/register/bloc/register_bloc.dart';

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

  /// Types a form, submits it and returns the settled state.
  Future<RegisterState> submit(Either<Failure, Unit> result) async {
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
    const result = Right<Failure, Unit>(unit);

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
    expect(state.isSubmitting, isTrue);
  });

  test('field errors focus the first field in layout order', () async {
    // Arrange
    const result = Left<Failure, Unit>(
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
    const result = Left<Failure, Unit>(Failure.conflict(code: 'conflict'));

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
    bloc.add(const RegisterEvent.emailEdited());
    await pumpEventQueue();

    // Assert
    expect(bloc.state.emailTaken, isFalse);
  });

  test('a server error shows the generic banner', () async {
    // Arrange
    const result = Left<Failure, Unit>(Failure.server(500));

    // Act
    final state = await submit(result);

    // Assert
    expect(state.formError, const AuthFormError.unexpected());
    expect(state.isSubmitting, isFalse);
  });
}
