import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';

/// The aliases as removable chips, with a field that adds one on Enter or a
/// comma.
class ProviderFormAliases extends StatelessWidget {
  const ProviderFormAliases({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onRemove,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<
      ProviderFormBloc,
      ProviderFormState,
      (List<String>, FieldError?, bool)
    >(
      selector: (state) => (state.aliases, state.aliasError, state.isWorking),
      builder: (context, field) {
        final (aliases, error, working) = field;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.fieldLabelGap,
          children: [
            Text(
              l10n.providerFormAliases,
              style: context.textTheme.labelMedium,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceSunken,
                borderRadius: MonAIRadius.mdAll,
                border: Border.all(
                  color: error == null ? c.border : c.error,
                  width: error == null ? 1 : 2,
                ),
              ),
              child: Padding(
                padding: const .symmetric(
                  horizontal: MonAISpacing.x2_5,
                  vertical: MonAISpacing.x2,
                ),
                child: Wrap(
                  spacing: MonAISpacing.x1_5,
                  runSpacing: MonAISpacing.x1_5,
                  crossAxisAlignment: .center,
                  children: [
                    ...aliases.map(
                      (alias) => _AliasChip(
                        alias: alias,
                        onRemove: working ? null : () => onRemove(alias),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: IntrinsicWidth(
                        child: TextField(
                          controller: controller,
                          enabled: !working,
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          style: context.textTheme.bodyLarge,
                          decoration: InputDecoration.collapsed(
                            hintText: aliases.isEmpty
                                ? l10n.providerFormAliasPlaceholder
                                : l10n.providerFormAliasAdd,
                            hintStyle: context.textTheme.bodyLarge?.copyWith(
                              color: c.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              switch (error) {
                final error? => error.text(l10n),
                null => l10n.providerFormAliasesNote,
              },
              style: context.textTheme.bodySmall?.copyWith(
                color: error == null ? c.textTertiary : c.errorText,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AliasChip extends StatelessWidget {
  const _AliasChip({required this.alias, this.onRemove});

  static const _height = 30.0;

  final String alias;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: _height,
      padding: const .only(left: MonAISpacing.x2_5, right: MonAISpacing.x1),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: MonAIRadius.smAll,
        border: Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(alias, style: context.textTheme.labelMedium),
          MonAIIconButton(
            icon: MonAIIcons.close,
            tooltip: context.l10n.providerFormAliasRemove(alias),
            onPressed: onRemove,
            size: 24,
            iconSize: 16,
            color: c.textTertiary,
          ),
        ],
      ),
    );
  }
}
