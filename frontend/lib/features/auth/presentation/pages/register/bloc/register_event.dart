part of 'register_bloc.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.nameEdited(String name) = _NameEdited;
  const factory RegisterEvent.emailEdited(String email) = _EmailEdited;
  const factory RegisterEvent.passwordEdited(String password) = _PasswordEdited;

  const factory RegisterEvent.submitted({
    required String name,
    required String email,
    required String password,
  }) = _Submitted;
}
