part of 'sign_in_bloc.dart';

@freezed
sealed class SignInEvent with _$SignInEvent {
  const factory SignInEvent.emailEdited(String email) = _EmailEdited;
  const factory SignInEvent.passwordEdited(String password) = _PasswordEdited;

  const factory SignInEvent.submitted({
    required String email,
    required String password,
  }) = _Submitted;
}
