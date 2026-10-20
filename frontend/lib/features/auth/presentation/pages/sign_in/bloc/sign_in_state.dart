part of 'sign_in_bloc.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    /// [UiStatus.loading] while signing in. [UiStatus.success] stays until
    /// the app leaves for Home; [UiStatus.failure] after a rejected attempt.
    @Default(UiStatus.initial) UiStatus status,
    FieldError? emailError,
    FieldError? passwordError,

    /// A problem with the whole attempt, shown as a banner.
    AuthFormError? formError,

    /// A submit failed on the input, so each edit re-checks its field.
    @Default(false) bool autovalidate,

    /// The first field with an error after a failed submit; the screen
    /// focuses it so the keyboard and screen reader land on the error.
    AuthField? focusField,
  }) = _SignInState;
}

extension SignInStateX on SignInState {
  /// A sign-in is running, or it succeeded and the app is switching screens.
  bool get isSubmitting => status == .loading || status == .success;
}
