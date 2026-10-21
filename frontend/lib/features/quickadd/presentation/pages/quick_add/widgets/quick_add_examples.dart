import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Example phrases; tapping one puts it in the input.
class QuickAddExamples extends StatelessWidget {
  const QuickAddExamples({
    required this.controller,
    required this.onPick,
    super.key,
  });

  /// The input, to mark the example it holds.
  final TextEditingController controller;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final examples = [
      l10n.quickAddExample1,
      l10n.quickAddExample2,
      l10n.quickAddExample3,
    ];
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x1_5,
      children: [
        Text(
          l10n.quickAddExamples,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) => Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x1_5,
            children: List.generate(
              examples.length,
              (index) => _Example(
                text: examples[index],
                selected: value.text.trim() == examples[index],
                onTap: () => onPick(examples[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Example extends StatelessWidget {
  const _Example({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.primaryContainer : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdAll,
          side: BorderSide(
            color: selected ? c.primaryContainerBorder : c.border,
          ),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: MonAISizes.touchTarget,
            ),
            child: Padding(
              padding: const .symmetric(
                horizontal: MonAISpacing.x3,
                vertical: MonAISpacing.x2_5,
              ),
              child: Align(
                alignment: .centerLeft,
                child: Text(
                  '“$text”',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
