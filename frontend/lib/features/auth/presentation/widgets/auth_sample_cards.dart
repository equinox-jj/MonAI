import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';

// Cards drawn on the auth illustrations: the onboarding pages and, later,
// the tablet auth hero.

/// The sample expense's category color: the server's default Food hex.
const authSampleFoodColor = Color(0xFFF97316);

/// Corners of the larger illustration cards.
const authIllustrationCardRadius = BorderRadius.all(Radius.circular(20));

const _sampleExpense = 35000;

/// A white card floating on the gradient.
class AuthIllustrationCard extends StatelessWidget {
  const AuthIllustrationCard({
    required this.borderRadius,
    required this.child,
    super.key,
    this.padding = const .symmetric(
      horizontal: MonAISpacing.x4,
      vertical: MonAISpacing.x3_5,
    ),
  });

  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33101828),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: c.textPrimary),
        child: child,
      ),
    );
  }
}

/// The sample quick-add sentence.
class AuthSamplePromptCard extends StatelessWidget {
  const AuthSamplePromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AuthIllustrationCard(
      borderRadius: MonAIRadius.fullAll,
      padding: const .symmetric(
        horizontal: MonAISpacing.x4,
        vertical: MonAISpacing.x3,
      ),
      child: Row(
        spacing: MonAISpacing.x2_5,
        children: [
          MonAIIcon(
            MonAIIcons.autoAwesome,
            size: MonAISizes.iconLg,
            color: c.accent,
          ),
          Expanded(
            child: Text(
              context.l10n.onboardingSamplePrompt,
              style: context.textTheme.bodyMedium
                  ?.withWeight(.w500)
                  .copyWith(color: c.iconStrong),
            ),
          ),
        ],
      ),
    );
  }
}

/// The expense the sample sentence becomes.
class AuthSampleExpenseCard extends StatelessWidget {
  const AuthSampleExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return AuthIllustrationCard(
      borderRadius: authIllustrationCardRadius,
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          const MonAICategoryIcon(
            icon: MonAIIcons.restaurant,
            color: authSampleFoodColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.onboardingSampleTitle,
                  style: context.textTheme.titleSmall?.withWeight(.w600),
                ),
                Text(
                  l10n.onboardingSampleMeta,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatRupiahSigned(_sampleExpense, negative: true),
            style: context.textTheme.titleSmall
                ?.withWeight(.w600)
                .tabular
                .copyWith(color: c.expense),
          ),
        ],
      ),
    );
  }
}
