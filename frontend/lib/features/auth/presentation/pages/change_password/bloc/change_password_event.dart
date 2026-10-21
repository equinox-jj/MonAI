part of 'change_password_bloc.dart';

@freezed
sealed class ChangePasswordEvent with _$ChangePasswordEvent {
  /// The current password was edited; carries the text for the live
  /// re-check.
  const factory ChangePasswordEvent.currentPasswordEdited(
    String currentPassword,
  ) = _CurrentPasswordEdited;

  /// The new password was edited; carries both fields' text, since the new
  /// one must differ from the current one.
  const factory ChangePasswordEvent.newPasswordEdited({
    required String newPassword,
    required String currentPassword,
  }) = _NewPasswordEdited;

  /// Save was tapped, or Done pressed on the new password, with the fields'
  /// text as typed.
  const factory ChangePasswordEvent.submitted({
    required String currentPassword,
    required String newPassword,
  }) = _Submitted;
}
