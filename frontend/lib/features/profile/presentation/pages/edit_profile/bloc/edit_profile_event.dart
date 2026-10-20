part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  /// The screen opened.
  const factory EditProfileEvent.started() = _Started;

  /// The cached user changed. Sent by the bloc itself.
  const factory EditProfileEvent.userChanged(User? user) = _UserChanged;

  /// The name field changed to [text].
  const factory EditProfileEvent.nameEdited(String text) = _NameEdited;

  /// Save, with the name field's text.
  const factory EditProfileEvent.saveRequested(String name) = _SaveRequested;

  /// A photo source was chosen: take or pick a photo, crop it, upload it.
  /// [cropLabels] are the cropper's words.
  const factory EditProfileEvent.photoSourcePicked(
    AvatarPhotoSource source,
    AvatarCropLabels cropLabels,
  ) = _PhotoSourcePicked;

  /// "Remove photo".
  const factory EditProfileEvent.removePhotoRequested() = _RemovePhotoRequested;

  /// The password field of the delete card changed.
  const factory EditProfileEvent.passwordEdited() = _PasswordEdited;

  /// "Delete my account", with the password field's text: asks to confirm
  /// once a password is typed.
  const factory EditProfileEvent.deleteRequested(String password) =
      _DeleteRequested;

  /// "Delete" in the confirm dialog.
  const factory EditProfileEvent.deleteConfirmed(String password) =
      _DeleteConfirmed;
}
