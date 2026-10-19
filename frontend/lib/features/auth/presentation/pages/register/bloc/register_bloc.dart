import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._register) : super(const RegisterState()) {
    on<_NameEdited>(_onNameEdited);
    on<_EmailEdited>(_onEmailEdited);
    on<_PasswordEdited>(_onPasswordEdited);
    on<_Submitted>(_onSubmitted);
  }

  final RegisterUseCase _register;

  // The typed values stay in the screen's text controllers; editing a field
  // only clears the errors it may have fixed.
  void _onNameEdited(_NameEdited event, Emitter<RegisterState> emit) {
    emit(state.copyWith(nameError: null, formError: null));
  }

  void _onEmailEdited(_EmailEdited event, Emitter<RegisterState> emit) {
    emit(state.copyWith(emailError: null, emailTaken: false, formError: null));
  }

  void _onPasswordEdited(_PasswordEdited event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        passwordLongEnough: AuthInputValidator.isPasswordLongEnough(
          event.password,
        ),
        passwordError: null,
        formError: null,
      ),
    );
  }

  /// On success the saved session moves the app to Home, so the form stays
  /// busy instead of briefly becoming submittable again.
  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: .loading, formError: null, focusField: null));
    final result = await _register(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    emit(result.match(_withFailure, (_) => state.copyWith(status: .success)));
  }

  RegisterState _withFailure(Failure failure) {
    switch (failure) {
      case ValidationFailure(:final fieldErrors):
        final nameError = fieldErrors.firstForField(
          AuthInputValidator.nameField,
        );
        final emailError = fieldErrors.firstForField(
          AuthInputValidator.emailField,
        );
        final passwordError = fieldErrors.firstForField(
          AuthInputValidator.passwordField,
        );
        // In layout order, whatever order the server listed the errors in.
        final focusField = nameError != null
            ? AuthField.name
            : emailError != null
            ? AuthField.email
            : passwordError != null
            ? AuthField.password
            : null;
        if (focusField != null) {
          return state.copyWith(
            status: .failure,
            nameError: nameError,
            emailError: emailError,
            emailTaken: false,
            passwordError: passwordError,
            focusField: focusField,
          );
        }
      case ConflictFailure():
        return state.copyWith(
          status: .failure,
          emailError: null,
          emailTaken: true,
          focusField: .email,
        );
      default:
    }
    return state.copyWith(status: .failure, formError: .fromFailure(failure));
  }
}
