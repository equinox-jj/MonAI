part of 'sign_in_bloc.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default(UiStatus.initial) UiStatus status,
    FieldError? emailError,
    FieldError? passwordError,
    AuthFormError? formError,
    @Default(false) bool autovalidate,
    AuthField? focusField,
  }) = _SignInState;
}
