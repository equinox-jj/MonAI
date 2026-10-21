import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/components/monai_badges.dart';
import 'package:monai/core/ui/designsystem/components/monai_surfaces.dart';
import 'package:monai/core/ui/designsystem/theme/monai_category_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

class MonAIWalletCard extends StatelessWidget {
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

  final String name;
  final String monogram;
  final WalletGradient gradient;
  final String balance;
  final String? balanceLabel;
  final String? defaultLabel;
  final bool compact;
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
