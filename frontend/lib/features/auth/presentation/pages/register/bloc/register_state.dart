part of 'register_bloc.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    /// [UiStatus.loading] while registering. [UiStatus.success] stays until
    /// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
    @Default(UiStatus.initial) UiStatus status,
    FieldError? nameError,
    FieldError? emailError,

    /// The email already has an account; the field offers "Sign in instead".
    @Default(false) bool emailTaken,
    FieldError? passwordError,

    /// Drives the live "At least 8 characters" hint.
    @Default(false) bool passwordLongEnough,

    /// A problem with the whole attempt, shown as a banner.
    AuthFormError? formError,

    /// A submit failed on the input, so each edit re-checks its field.
    @Default(false) bool autovalidate,

    /// The first field with an error after a failed submit; the screen
    /// focuses it so the keyboard and screen reader land on the error.
    AuthField? focusField,
  }) = _RegisterState;
}

extension RegisterStateX on RegisterState {
  /// A register call is running, or it succeeded and the app is switching
  /// screens.
  bool get isSubmitting => status == .loading || status == .success;
}
