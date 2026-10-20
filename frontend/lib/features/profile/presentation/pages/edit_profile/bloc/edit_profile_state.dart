part of 'edit_profile_bloc.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    /// The signed-in user; null until the cache answers.
    User? user,

    /// The typed name differs from the saved one.
    @Default(false) bool nameChanged,
    FieldError? nameError,

    /// A save failed on the name, so it is checked as the user types.
    @Default(false) bool autovalidate,
    @Default(false) bool isSavingName,

    /// The share of the photo uploaded, 0 to 1; null when not uploading.
    double? uploadProgress,

    /// Picking, cropping or shrinking a photo before the upload.
    @Default(false) bool isPreparingPhoto,
    @Default(false) bool isRemovingPhoto,

    /// Under the password of the delete card.
    FieldError? passwordError,
    @Default(false) bool isDeleting,

    /// The confirm dialog shows once.
    @Default(false) bool askDelete,

    /// What went through; shown once as a snackbar.
    ProfileNotice? notice,

    /// Why a change failed; shown once as a snackbar.
    ProfileFailure? failure,
  }) = _EditProfileState;
}

extension EditProfileStateX on EditProfileState {
  bool get canSave => nameChanged && !isSavingName;

  bool get isChangingPhoto =>
      isPreparingPhoto || uploadProgress != null || isRemovingPhoto;

  bool get hasPhoto => user?.avatarUrl != null;
}

/// The cropper's title and buttons, in the app's language.
@immutable
class AvatarCropLabels {
  const AvatarCropLabels({
    required this.title,
    required this.done,
    required this.cancel,
  });

  final String title;
  final String done;
  final String cancel;

  @override
  bool operator ==(Object other) =>
      other is AvatarCropLabels &&
      other.title == title &&
      other.done == done &&
      other.cancel == cancel;

  @override
  int get hashCode => Object.hash(title, done, cancel);
}
