part of 'change_password_bloc.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    /// [UiStatus.loading] while saving. [UiStatus.success] stays while the
    /// app signs out; [UiStatus.failure] after a rejected attempt.
    @Default(UiStatus.initial) UiStatus status,
    FieldError? currentPasswordError,
    FieldError? newPasswordError,

    /// The new password meets the minimum length; drives the live hint.
    @Default(false) bool newPasswordLongEnough,

    /// A problem with the whole attempt (offline, rate limited), shown as a
    /// banner.
    AuthFormError? formError,

    /// A submit failed on the input, so each edit re-checks its field.
    @Default(false) bool autovalidate,

    /// The first field with an error after a failed submit; the screen
    /// focuses it so the keyboard and screen reader land on the error.
    AuthField? focusField,
  }) = _ChangePasswordState;
}

extension ChangePasswordStateX on ChangePasswordState {
  /// A change is running, or it succeeded and the app is signing out.
  bool get isSubmitting => status == .loading || status == .success;
}
