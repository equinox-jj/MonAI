part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.started() = _Started;
  const factory EditProfileEvent.userChanged(User? user) = _UserChanged;
  const factory EditProfileEvent.nameEdited(String text) = _NameEdited;
  const factory EditProfileEvent.saveRequested(String name) = _SaveRequested;

  const factory EditProfileEvent.photoSourcePicked(
    AvatarPhotoSource source,
    AvatarCropLabels cropLabels,
  ) = _PhotoSourcePicked;

  const factory EditProfileEvent.removePhotoRequested() = _RemovePhotoRequested;
  const factory EditProfileEvent.passwordEdited() = _PasswordEdited;

  const factory EditProfileEvent.deleteRequested(String password) =
      _DeleteRequested;

  const factory EditProfileEvent.deleteConfirmed(String password) =
      _DeleteConfirmed;
}
