import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';

/// The Active switch. On an existing provider it applies at once; a system
/// provider is always active.
class ProviderFormActiveRow extends StatelessWidget {
  const ProviderFormActiveRow({required this.onToggled, super.key});

  final ValueChanged<bool> onToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      ProviderFormBloc,
      ProviderFormState,
      (bool, bool, bool, bool)
    >(
      selector: (state) => (
        state.isActive,
        state.isNew,
        state.isSystem,
        state.isWorking || !state.canSave,
      ),
      builder: (context, row) {
        final (active, isNew, system, locked) = row;
        final enabled = !system && !locked;
        final note = system
            ? l10n.providerFormSystemNote
            : isNew
            ? l10n.providerFormActiveNoteNew
            : l10n.providerFormActiveNoteEdit;
        return MergeSemantics(
          child: InkWell(
            onTap: enabled ? () => onToggled(!active) : null,
            borderRadius: MonAIRadius.mdAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: MonAISizes.buttonMedium,
              ),
              child: Row(
                spacing: MonAISpacing.x3,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          l10n.providerFormActive,
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          note,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: active,
                    activeThumbColor: c.onPrimary,
                    activeTrackColor: c.primary,
                    onChanged: enabled ? onToggled : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
