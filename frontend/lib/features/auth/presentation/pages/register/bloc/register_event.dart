part of 'register_bloc.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  /// The name field was edited; carries the text for the live re-check.
  const factory RegisterEvent.nameEdited(String name) = _NameEdited;

  /// The email field was edited; carries the text for the live re-check.
  const factory RegisterEvent.emailEdited(String email) = _EmailEdited;

  /// The password field was edited. Carries the text for the live length
  /// hint and re-check; it is not kept in the state.
  const factory RegisterEvent.passwordEdited(String password) = _PasswordEdited;

  /// Create account was tapped, or Done pressed on the password field, with
  /// the fields' text as typed.
  const factory RegisterEvent.submitted({
    required String name,
    required String email,
    required String password,
  }) = _Submitted;
}
