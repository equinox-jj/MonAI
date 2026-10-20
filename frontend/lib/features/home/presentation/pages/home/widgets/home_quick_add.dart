import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';

/// The natural-language entry and the receipt scanner, with a hint below.
class HomeQuickAdd extends StatelessWidget {
  const HomeQuickAdd({
    required this.onQuickAdd,
    required this.onScanReceipt,
    super.key,
  });

  final VoidCallback onQuickAdd;
  final VoidCallback onScanReceipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        HomeQuickAddBar(onQuickAdd: onQuickAdd, onScanReceipt: onScanReceipt),
        Padding(
          padding: const .only(left: MonAISpacing.x4),
          child: Text(
            context.l10n.homeQuickAddHelper,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

/// The quick-add pill and the scan button side by side; the tablet header
/// shows it without the hint.
class HomeQuickAddBar extends StatelessWidget {
  const HomeQuickAddBar({
    required this.onQuickAdd,
    required this.onScanReceipt,
    super.key,
    this.height = MonAISizes.quickAddField,
  });

  final VoidCallback onQuickAdd;
  final VoidCallback onScanReceipt;

  /// 52 on phones and tablet portrait, 48 in tablet landscape.
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        Expanded(
          child: MonAIPillField(
            text: l10n.homeQuickAddExample,
            leadingIcon: MonAIIcons.autoAwesome,
            leadingIconColor: context.colors.accent,
            onTap: onQuickAdd,
            height: height,
          ),
        ),
        MonAIIconButton(
          icon: MonAIIcons.documentScanner,
          tooltip: l10n.homeScanReceipt,
          onPressed: onScanReceipt,
          style: .tonal,
          size: height,
        ),
      ],
    );
  }
}
