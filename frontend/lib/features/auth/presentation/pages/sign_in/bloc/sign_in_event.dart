part of 'sign_in_bloc.dart';

@freezed
sealed class SignInEvent with _$SignInEvent {
  /// The email field was edited; carries the text for the live re-check.
  const factory SignInEvent.emailEdited(String email) = _EmailEdited;

  /// The password field was edited; carries the text for the live re-check.
  const factory SignInEvent.passwordEdited(String password) = _PasswordEdited;

  /// Sign in was tapped, or Done pressed on the password field, with the
  /// fields' text as typed.
  const factory SignInEvent.submitted({
    required String email,
    required String password,
  }) = _Submitted;
}
