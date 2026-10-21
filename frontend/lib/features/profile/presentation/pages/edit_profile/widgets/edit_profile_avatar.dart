import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({
    required this.onChangePhoto,
    required this.onRemovePhoto,
    super.key,
  });

  static const _ring = 112.0;
  static const _avatar = 96.0;
  static const _badge = 36.0;
  static const _ringStroke = 4.0;

  final VoidCallback onChangePhoto;
  final VoidCallback onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      EditProfileBloc,
      EditProfileState,
      (String, String?, double?, bool, bool, bool)
    >(
      selector: (state) => (
        initialsOf(state.user?.name ?? ''),
        state.user?.avatarUrl,
        state.uploadProgress,
        state.isPreparingPhoto,
        state.isRemovingPhoto,
        state.hasPhoto,
      ),
      builder: (context, selected) {
        final (initials, url, progress, preparing, removing, hasPhoto) =
            selected;
        final busy = progress != null || preparing || removing;
        final status = switch ((progress, preparing, removing)) {
          (final p?, _, _) => l10n.profileUploading((p * 100).round()),
          (null, true, _) => l10n.profilePreparingPhoto,
          (null, false, true) => l10n.profileRemovingPhoto,
          _ => null,
        };
        return Column(
          spacing: MonAISpacing.x3,
          children: [
            SizedBox.square(
              dimension: _ring,
              child: Stack(
                alignment: .center,
                children: [
                  if (busy)
                    SizedBox.square(
                      dimension: _ring,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: _ringStroke,
                        color: c.accent,
                        backgroundColor: c.border,
                      ),
                    ),
                  MonAIAvatar(initials: initials, imageUrl: url, size: _avatar),
                  Positioned(
                    right: MonAISpacing.x1,
                    bottom: MonAISpacing.x1,
                    child: Semantics(
                      button: true,
                      label: l10n.profileChangePhotoDescription,
                      excludeSemantics: true,
                      child: Material(
                        color: c.primary,
                        shape: CircleBorder(
                          side: BorderSide(color: c.surface, width: 3),
                        ),
                        clipBehavior: .antiAlias,
                        child: InkWell(
                          onTap: busy ? null : onChangePhoto,
                          child: SizedBox.square(
                            dimension: _badge,
                            child: Center(
                              child: MonAIIcon(
                                MonAIIcons.photoCamera,
                                size: MonAISizes.iconMd,
                                color: c.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (status != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  status,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: .center,
              spacing: MonAISpacing.x2,
              children: [
                MonAIButton(
                  label: l10n.profileChangePhoto,
                  leadingIcon: MonAIIcons.photoLibrary,
                  variant: .tonal,
                  size: .small,
                  onPressed: busy ? null : onChangePhoto,
                ),
                if (hasPhoto)
                  MonAIButton(
                    label: l10n.profileRemovePhoto,
                    variant: .outlined,
                    size: .small,
                    onPressed: busy ? null : onRemovePhoto,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
