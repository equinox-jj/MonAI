part of 'edit_profile_bloc.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    User? user,
    @Default(false) bool nameChanged,
    FieldError? nameError,
    @Default(false) bool autovalidate,
    @Default(false) bool isSavingName,
    double? uploadProgress,
    @Default(false) bool isPreparingPhoto,
    @Default(false) bool isRemovingPhoto,
    FieldError? passwordError,
    @Default(false) bool isDeleting,
    @Default(false) bool askDelete,
    ProfileNotice? notice,
    ProfileFailure? failure,
  }) = _EditProfileState;
}

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
