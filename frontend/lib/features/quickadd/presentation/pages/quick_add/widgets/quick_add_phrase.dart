import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';

class QuickAddPhrase extends StatelessWidget {
  const QuickAddPhrase({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });

  static const _maxLength = 300;

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: MonAIRadius.lgAll,
        border: Border.all(color: c.accent, width: MonAISizes.borderFocused),
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x4,
          vertical: MonAISpacing.x3_5,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x3,
          children: [
            Row(
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x2_5,
              children: [
                Padding(
                  padding: const .only(top: MonAISpacing.x0_5),
                  child: MonAIIcon(
                    MonAIIcons.autoAwesome,
                    size: MonAISizes.iconLg,
                    color: c.accent,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    onChanged: onChanged,
                    onSubmitted: (_) => onSubmitted(),
                    maxLength: _maxLength,
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    style: t.titleMedium?.copyWith(color: c.textPrimary),
                    decoration: MonAIMarkedField.bareDecoration(
                      hint: l10n.quickAddPlaceholder,
                      hintStyle: t.titleMedium?.copyWith(color: c.textTertiary),
                    ).copyWith(semanticCounterText: ''),
                  ),
                ),
              ],
            ),
            const _Chips(),
          ],
        ),
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return BlocSelector<QuickAddBloc, QuickAddState, List<QuickAddChip>>(
      selector: (state) => switch (state.context) {
        final parseContext? => quickAddChips(
          state.drafts,
          parseContext,
          l10n,
          locale,
        ),
        null => const [],
      },
      builder: (context, chips) => chips.isEmpty
          ? const SizedBox.shrink()
          : Semantics(
              label: l10n.quickAddUnderstood,
              container: true,
              child: Wrap(
                spacing: MonAISpacing.x1_5,
                runSpacing: MonAISpacing.x1_5,
                children: List.generate(
                  chips.length,
                  (index) => _Chip(chip: chips[index]),
                ),
              ),
            ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.chip});

  final QuickAddChip chip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (container, content) = chip.unsure
        ? (c.warningContainer, c.onWarningContainer)
        : (c.primaryContainer, c.onPrimaryContainer);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: container,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: SizedBox(
        height: 28,
        child: Padding(
          padding: const .symmetric(horizontal: MonAISpacing.x2_5),
          child: Row(
            mainAxisSize: .min,
            spacing: MonAISpacing.x1,
            children: [
              MonAIIcon(
                chip.unsure ? MonAIIcons.help : chip.icon,
                size: MonAISizes.iconSm,
                color: content,
              ),
              Text(
                chip.text,
                style: context.textTheme.labelSmall?.copyWith(
                  color: content,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
