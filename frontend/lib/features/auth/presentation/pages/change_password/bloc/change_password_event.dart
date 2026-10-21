part of 'change_password_bloc.dart';

@freezed
sealed class ChangePasswordEvent with _$ChangePasswordEvent {
  const factory ChangePasswordEvent.currentPasswordEdited(
    String currentPassword,
  ) = _CurrentPasswordEdited;

  const factory ChangePasswordEvent.newPasswordEdited({
    required String newPassword,
    required String currentPassword,
  }) = _NewPasswordEdited;

  const factory ChangePasswordEvent.submitted({
    required String currentPassword,
    required String newPassword,
  }) = _Submitted;
}
