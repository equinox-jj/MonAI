import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';

extension EditProfileStateX on EditProfileState {
  bool get canSave => nameChanged && !isSavingName;

  bool get isChangingPhoto =>
      isPreparingPhoto || uploadProgress != null || isRemovingPhoto;

  bool get hasPhoto => user?.avatarUrl != null;
}
