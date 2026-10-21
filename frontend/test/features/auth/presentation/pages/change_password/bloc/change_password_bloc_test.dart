import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/change_password/bloc/change_password_bloc.dart';

class _MockChangePasswordUseCase extends Mock
    implements ChangePasswordUseCase {}

const _currentRequired = FieldError(
  field: 'current_password',
  code: 'required',
  message: 'is required',
);

const _newTooShort = FieldError(
  field: 'new_password',
  code: 'min_length',
  message: 'must be at least 8 characters',
  params: {'min': 8},
);

const _submitted = ChangePasswordEvent.submitted(
  currentPassword: 'old-secret',
  newPassword: 'new-secret',
);

void main() {
  late _MockChangePasswordUseCase changePassword;
  late ChangePasswordBloc bloc;

  setUpAll(
    () => registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', newPassword: ''),
    ),
  );

  setUp(() {
    changePassword = _MockChangePasswordUseCase();
    bloc = ChangePasswordBloc(changePassword);
  });

  tearDown(() => bloc.close());

  Future<ChangePasswordState> submit(
    Either<Failure, SessionStatus> result, {
    ChangePasswordEvent event = _submitted,
  }) async {
    when(() => changePassword(any())).thenAnswer((_) async => result);
    bloc.add(event);
    await pumpEventQueue();
    return bloc.state;
  }

  test('sends the submitted form and stays busy on success', () async {
    // Arrange
    const result = Right<Failure, SessionStatus>(SessionStatus.passwordChanged);

    // Act
    final state = await submit(result);

    // Assert
    verify(
      () => changePassword(
        any(
          that: isA<ChangePasswordParams>()
              .having((p) => p.currentPassword, 'current', 'old-secret')
              .having((p) => p.newPassword, 'new', 'new-secret'),
        ),
      ),
    ).called(1);
    expect(state.status, UiStatus.success);
    expect(state.status.isSubmitting, isTrue);
  });

  test('a second submit while saving is ignored', () async {
    // Arrange
    when(() => changePassword(any()))
        .thenAnswer((_) async => const Right(SessionStatus.passwordChanged));

    // Act
    bloc
      ..add(_submitted)
      ..add(_submitted);
    await pumpEventQueue();

    // Assert
    verify(() => changePassword(any())).called(1);
  });

  test('field errors land on their fields and focus the first one', () async {
    // Arrange
    // Listed out of layout order, as the server may.
    const result = Left<Failure, SessionStatus>(
      Failure.validation([_newTooShort, _currentRequired]),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.status, UiStatus.failure);
    expect(state.currentPasswordError, _currentRequired);
    expect(state.newPasswordError, _newTooShort);
    expect(state.focusField, AuthField.currentPassword);
    expect(state.autovalidate, isTrue);
    expect(state.formError, isNull);
  });

  test('a wrong current password lands on the current field', () async {
    // Arrange
    const result = Left<Failure, SessionStatus>(
      Failure.validation([], code: 'invalid_password'),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.currentPasswordError?.code, 'invalid_password');
    expect(state.currentPasswordError?.field, 'current_password');
    expect(state.newPasswordError, isNull);
    expect(state.focusField, AuthField.currentPassword);
  });

  test('being offline shows the network banner', () async {
    // Arrange
    const result = Left<Failure, SessionStatus>(Failure.network());

    // Act
    final state = await submit(result);

    // Assert
    expect(state.status, UiStatus.failure);
    expect(state.formError, const AuthFormError.network());
    expect(state.focusField, isNull);
    expect(state.status.isSubmitting, isFalse);
  });

  test('a rate limit shows its wait in minutes', () async {
    // Arrange
    const result = Left<Failure, SessionStatus>(
      Failure.tooManyRequests(retryAfter: Duration(seconds: 61)),
    );

    // Act
    final state = await submit(result);

    // Assert
    expect(state.formError, const AuthFormError.rateLimited(minutes: 2));
  });

  test('editing before a failed submit shows no field errors', () async {
    // Arrange
    // (a fresh form)

    // Act
    bloc
      ..add(const ChangePasswordEvent.currentPasswordEdited(''))
      ..add(
        const ChangePasswordEvent.newPasswordEdited(
          newPassword: 'short',
          currentPassword: '',
        ),
      );
    await pumpEventQueue();

    // Assert
    expect(bloc.state.currentPasswordError, isNull);
    expect(bloc.state.newPasswordError, isNull);
  });

  test('the length hint follows the new password as it is typed', () async {
    // Arrange
    // (a fresh form)

    // Act
    bloc.add(
      const ChangePasswordEvent.newPasswordEdited(
        newPassword: 'long-enough',
        currentPassword: '',
      ),
    );
    await pumpEventQueue();

    // Assert
    expect(bloc.state.newPasswordLongEnough, isTrue);
  });

  test('after a failed submit each edit re-checks its field', () async {
    // Arrange
    await submit(
      const Left(Failure.validation([_currentRequired, _newTooShort])),
    );

    // Act
    bloc
      ..add(const ChangePasswordEvent.currentPasswordEdited('old-secret'))
      ..add(
        const ChangePasswordEvent.newPasswordEdited(
          newPassword: 'old-secret',
          currentPassword: 'old-secret',
        ),
      );
    await pumpEventQueue();

    // Assert
    expect(bloc.state.currentPasswordError, isNull);
    expect(bloc.state.newPasswordError?.code, 'not_equal');
  });

  test('an edit clears a wrong current password and the banner', () async {
    // Arrange
    await submit(const Left(Failure.validation([], code: 'invalid_password')));

    // Act
    bloc.add(const ChangePasswordEvent.currentPasswordEdited('other'));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.currentPasswordError, isNull);
    expect(bloc.state.formError, isNull);
  });
}
