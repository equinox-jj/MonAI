import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';

/// Asks before hiding [name] from users adding a wallet; pops true to go
/// ahead.
class ProviderDeactivateDialog extends StatelessWidget {
  const ProviderDeactivateDialog({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MonAIAlertDialog(
      title: l10n.providerDeactivateTitle(name),
      message: l10n.providerDeactivateMessage(name),
      icon: MonAIIcons.visibilityOff,
      confirmLabel: l10n.providerDeactivateConfirm,
      onConfirm: () => Navigator.pop(context, true),
      dismissLabel: l10n.providerCancel,
      onDismiss: () => Navigator.pop(context, false),
      content: _Notes(
        notes: [
          (MonAIIcons.checkCircle, c.success, l10n.providerDeactivateKeeps),
          (MonAIIcons.checkCircle, c.success, l10n.providerDeactivateUndo),
        ],
      ),
    );
  }
}

/// Asks before deleting [name]; pops true to go ahead.
class ProviderDeleteDialog extends StatelessWidget {
  const ProviderDeleteDialog({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MonAIAlertDialog(
      title: l10n.providerDeleteTitle(name),
      message: l10n.providerDeleteMessage(name),
      icon: MonAIIcons.delete,
      tone: .error,
      destructive: true,
      confirmLabel: l10n.providerDeleteConfirm,
      onConfirm: () => Navigator.pop(context, true),
      dismissLabel: l10n.providerCancel,
      onDismiss: () => Navigator.pop(context, false),
      content: _Notes(
        notes: [
          (MonAIIcons.sell, c.textSecondary, l10n.providerDeleteAliases),
          (MonAIIcons.image, c.textSecondary, l10n.providerDeleteLogo),
        ],
      ),
    );
  }
}

/// What happens, in a soft box under the message.
class _Notes extends StatelessWidget {
  const _Notes({required this.notes});

  final List<(MonAIIconData, Color, String)> notes;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: MonAIRadius.mdAll,
      ),
      child: Padding(
        padding: const .all(MonAISpacing.x3),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: notes
              .map(
                (note) => Row(
                  crossAxisAlignment: .start,
                  spacing: MonAISpacing.x2,
                  children: [
                    MonAIIcon(note.$1, size: MonAISizes.iconMd, color: note.$2),
                    Expanded(
                      child: Text(
                        note.$3,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
