import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';
import 'package:monai/features/auth/domain/validation/auth_input.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this._login) : super(const SignInState()) {
    on<_EmailEdited>(_onEmailEdited);
    on<_PasswordEdited>(_onPasswordEdited);
    on<_Submitted>(_onSubmitted);
  }

  final LoginUseCase _login;

  // Field errors stay hidden until a submit fails on the input; after that,
  // each edit re-checks its field. An edit always clears the banner, since
  // only the next submit can tell whether the problem is still there.
  void _onEmailEdited(_EmailEdited event, Emitter<SignInState> emit) {
    emit(
      state.copyWith(
        emailError: state.autovalidate
            ? AuthInputValidator.loginEmail(event.email.normalizedEmail)
            : state.emailError,
        formError: null,
      ),
    );
  }

  void _onPasswordEdited(_PasswordEdited event, Emitter<SignInState> emit) {
    emit(
      state.copyWith(
        passwordError: state.autovalidate
            ? AuthInputValidator.loginPassword(event.password)
            : state.passwordError,
        formError: null,
      ),
    );
  }

  /// On success the saved session moves the app to Home, so the form stays
  /// busy instead of briefly becoming submittable again.
  Future<void> _onSubmitted(_Submitted event, Emitter<SignInState> emit) async {
    if (state.status.isSubmitting) return;
    emit(state.copyWith(status: .loading, formError: null, focusField: null));

    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );

    emit(result.match(_withFailure, (_) => state.copyWith(status: .success)));
  }

  SignInState _withFailure(Failure failure) {
    if (failure case ValidationFailure(:final fieldErrors)) {
      final emailError = fieldErrors.firstForField(
        AuthInputValidator.emailField,
      );
      final passwordError = fieldErrors.firstForField(
        AuthInputValidator.passwordField,
      );
      // In layout order, whatever order the server listed the errors in.
      final focusField = emailError != null
          ? AuthField.email
          : passwordError != null
          ? AuthField.password
          : null;
      if (focusField != null) {
        return state.copyWith(
          status: .failure,
          emailError: emailError,
          passwordError: passwordError,
          focusField: focusField,
          autovalidate: true,
        );
      }
    }
    return state.copyWith(status: .failure, formError: .fromFailure(failure));
  }
}
