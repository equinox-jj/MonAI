import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';

part 'change_password_bloc.freezed.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(this._changePassword)
    : super(const ChangePasswordState()) {
    on<_CurrentPasswordEdited>(_onCurrentPasswordEdited);
    on<_NewPasswordEdited>(_onNewPasswordEdited);
    on<_Submitted>(_onSubmitted);
  }

  final ChangePasswordUseCase _changePassword;
  static const _invalidPasswordCode = 'invalid_password';

  // Field errors stay hidden until a submit fails on the input; after that,
  // each edit re-checks its field, which also clears a wrong current
  // password. An edit always clears the banner.
  void _onCurrentPasswordEdited(
    _CurrentPasswordEdited event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(
        currentPasswordError: state.autovalidate
            ? AuthInputValidator.changeCurrentPassword(event.currentPassword)
            : state.currentPasswordError,
        formError: null,
      ),
    );
  }

  void _onNewPasswordEdited(
    _NewPasswordEdited event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(
        newPasswordLongEnough: AuthInputValidator.isPasswordLongEnough(
          event.newPassword,
        ),
        newPasswordError: state.autovalidate
            ? AuthInputValidator.changeNewPassword(
                event.newPassword,
                currentPassword: event.currentPassword,
              )
            : state.newPasswordError,
        formError: null,
      ),
    );
  }

  /// On success the session ends and the password-changed dialog covers the
  /// app, so the form stays busy instead of becoming submittable again.
  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.status.isSubmitting) return;
    emit(state.copyWith(status: .loading, formError: null, focusField: null));
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );
    emit(result.match(_withFailure, (_) => state.copyWith(status: .success)));
  }

  ChangePasswordState _withFailure(Failure failure) {
    if (failure case ValidationFailure(:final fieldErrors, :final code)) {
      final currentError = code == _invalidPasswordCode
          ? const FieldError(
              field: AuthInputValidator.currentPasswordField,
              code: _invalidPasswordCode,
              message: 'The password is incorrect',
            )
          : fieldErrors.firstForField(AuthInputValidator.currentPasswordField);
      final newError = fieldErrors.firstForField(
        AuthInputValidator.newPasswordField,
      );
      // In layout order, whatever order the server listed the errors in.
      final focusField = currentError != null
          ? AuthField.currentPassword
          : newError != null
          ? AuthField.newPassword
          : null;
      if (focusField != null) {
        return state.copyWith(
          status: .failure,
          currentPasswordError: currentError,
          newPasswordError: newError,
          focusField: focusField,
          autovalidate: true,
        );
      }
    }
    return state.copyWith(status: .failure, formError: .fromFailure(failure));
  }
}
