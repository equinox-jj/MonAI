part of 'change_password_bloc.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(UiStatus.initial) UiStatus status,
    FieldError? currentPasswordError,
    FieldError? newPasswordError,
    @Default(false) bool newPasswordLongEnough,
    AuthFormError? formError,
    @Default(false) bool autovalidate,
    AuthField? focusField,
  }) = _ChangePasswordState;
}
