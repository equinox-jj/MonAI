part of 'register_bloc.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(UiStatus.initial) UiStatus status,
    FieldError? nameError,
    FieldError? emailError,
    @Default(false) bool emailTaken,
    FieldError? passwordError,
    @Default(false) bool passwordLongEnough,
    AuthFormError? formError,
    @Default(false) bool autovalidate,
    AuthField? focusField,
  }) = _RegisterState;
}

extension RegisterStateX on RegisterState {
  bool get isSubmitting => status == .loading || status == .success;
}
