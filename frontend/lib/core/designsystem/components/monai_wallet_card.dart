import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/components/monai_badges.dart';
import 'package:monai/core/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/designsystem/theme/monai_category_colors.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// A wallet on its gradient: monogram, name and the "Default" pill at the
/// top, the balance at the bottom. Size it with its parent.
///
/// [compact] is the small tablet-grid card: smaller monogram, name and
/// balance, no [balanceLabel].
class MonAIWalletCard extends StatelessWidget {
  /// Creates a wallet card.
  const MonAIWalletCard({
    required this.name,
    required this.monogram,
    required this.gradient,
    required this.balance,
    super.key,
    this.balanceLabel,
    this.defaultLabel,
    this.compact = false,
    this.onTap,
  });

  /// The wallet's name.
  final String name;

  /// Two or three letters standing in for the logo.
  final String monogram;

  /// The card colors.
  final WalletGradient gradient;

  /// Already formatted, or the hidden-amount mask.
  final String balance;

  /// A line above the balance, e.g. "Bank · balance".
  final String? balanceLabel;

  /// The pill text when this is the default wallet; null hides the pill.
  final String? defaultLabel;

  /// The small tablet-grid layout.
  final bool compact;

  /// Opens the wallet.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    return MonAIGradientCard(
      gradient: gradient.gradient,
      borderRadius: MonAIRadius.lgAll,
      padding: .all(compact ? MonAISpacing.x3_5 : MonAISpacing.cardPadding),
      elevated: false,
      decorated: false,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            spacing: compact ? MonAISpacing.x2 : MonAISpacing.x2_5,
            children: [
              MonAIMonogram(
                text: monogram,
                contentColor: gradient.start,
                size: compact ? MonAISizes.iconXl : MonAISizes.avatarSmall,
              ),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: (compact ? t.labelLarge : t.titleMedium)?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              if (defaultLabel case final label?) MonAIPill(text: label),
            ],
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              if (balanceLabel case final label? when !compact)
                Text(
                  label,
                  style: t.bodySmall?.copyWith(color: gradient.muted),
                ),
              Text(
                balance,
                maxLines: 1,
                style: compact
                    ? t.titleLarge?.withWeight(.w700).tabular
                    : context.textStyles.amountLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
