import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/data/services/avatar_photo_service.dart';

/// Where the new profile photo comes from, or removing it.
class EditProfilePhotoSheet extends StatelessWidget {
  const EditProfilePhotoSheet({
    required this.hasPhoto,
    required this.onSource,
    required this.onRemove,
    super.key,
  });

  /// Offers "Remove photo" only when there is one.
  final bool hasPhoto;
  final ValueChanged<AvatarPhotoSource> onSource;
  final VoidCallback onRemove;

  void _pick(BuildContext context, AvatarPhotoSource source) {
    Navigator.pop(context);
    onSource(source);
  }

  void _remove(BuildContext context) {
    Navigator.pop(context);
    onRemove();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x1,
      children: [
        _Option(
          icon: MonAIIcons.photoCamera,
          title: l10n.profilePhotoCamera,
          note: l10n.profilePhotoCameraNote,
          onTap: () => _pick(context, AvatarPhotoSource.camera),
        ),
        _Option(
          icon: MonAIIcons.photoLibrary,
          title: l10n.profilePhotoGallery,
          note: l10n.profilePhotoGalleryNote,
          onTap: () => _pick(context, AvatarPhotoSource.gallery),
        ),
        if (hasPhoto)
          _Option(
            icon: MonAIIcons.delete,
            title: l10n.profilePhotoRemove,
            note: l10n.profilePhotoRemoveNote,
            destructive: true,
            onTap: () => _remove(context),
          ),
        Padding(
          padding: const .only(top: MonAISpacing.x2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surfaceSunken,
              borderRadius: MonAIRadius.mdAll,
            ),
            child: Padding(
              padding: const .all(MonAISpacing.x3),
              child: Row(
                crossAxisAlignment: .start,
                spacing: MonAISpacing.x2_5,
                children: [
                  MonAIIcon(
                    MonAIIcons.shield,
                    size: MonAISizes.iconMd,
                    color: c.success,
                  ),
                  Expanded(
                    child: Text(
                      l10n.profilePhotoPrivacy,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.note,
    required this.onTap,
    this.destructive = false,
  });

  final MonAIIconData icon;
  final String title;
  final String note;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    final (container, content) = destructive
        ? (c.errorContainer, c.error)
        : (c.primaryContainer, c.accent);
    return Material(
      color: Colors.transparent,
      borderRadius: MonAIRadius.mdAll,
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: MonAISizes.pickerOption),
          child: Padding(
            padding: const .symmetric(horizontal: MonAISpacing.x2),
            child: Row(
              spacing: MonAISpacing.x3_5,
              children: [
                SizedBox.square(
                  dimension: MonAISizes.avatarLarge,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: container,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: MonAIIcon(icon, color: content)),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        title,
                        style: t.titleSmall?.copyWith(
                          color: destructive ? c.errorText : c.textPrimary,
                        ),
                      ),
                      Text(
                        note,
                        style: t.bodySmall?.copyWith(color: c.textTertiary),
                      ),
                    ],
                  ),
                ),
                if (!destructive)
                  MonAIIcon(MonAIIcons.chevronRight, color: c.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
