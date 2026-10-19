import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';
import 'package:monai/features/auth/presentation/widgets/auth_sample_cards.dart';

// Sample data drawn in the illustrations. Category colors are the server's
// default category hexes.
const _billsColor = Color(0xFF8B5CF6);
const _transportColor = Color(0xFF0EA5E9);

const _bcaBalance = 8250000;
const _goPayBalance = 1185000;
const _cashBalance = 450000;
const _budgetLeft = 585000;

const _walletMonogramSize = 36.0;
const _breakdownLabelWidth = 64.0;
const _breakdownPercentWidth = 32.0;

/// The indigo panel at the top of each page. The illustration is decorative,
/// so it is hidden from screen readers.
class OnboardingHero extends StatelessWidget {
  const OnboardingHero({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: MonAIRadius.xxxlAll,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: context.colors.heroGradient),
        child: Stack(
          fit: .expand,
          children: [
            ...switch (step) {
              .capture => const [
                _DecorCircle(left: -60, top: -60, size: 220, alpha: 0.07),
                _DecorCircle(right: -40, bottom: -80, size: 240, alpha: 0.06),
              ],
              .wallets => const [
                _DecorCircle(right: -60, top: -60, size: 220, alpha: 0.07),
              ],
              .insights => const [
                _DecorCircle(left: -60, bottom: -60, size: 220, alpha: 0.07),
              ],
            },
            _Illustration(step: step),
          ],
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({
    required this.size,
    required this.alpha,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  final double size;
  final double alpha;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}

/// The page's sample cards, centered and scaled down when the panel is too
/// short to fit them.
class _Illustration extends StatelessWidget {
  const _Illustration({required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const .all(MonAISpacing.x6),
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: FittedBox(
              fit: .scaleDown,
              child: SizedBox(
                width: constraints.maxWidth,
                child: switch (step) {
                  .capture => const _CaptureIllustration(),
                  .wallets => const _WalletsIllustration(),
                  .insights => const _InsightsIllustration(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Page 1: a typed sentence becomes a categorised expense.
class _CaptureIllustration extends StatelessWidget {
  const _CaptureIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: MonAISpacing.x3_5,
      children: [
        const AuthSamplePromptCard(),
        MonAIIcon(
          MonAIIcons.south,
          size: MonAISizes.iconXl,
          color: context.colors.highlight,
        ),
        const AuthSampleExpenseCard(),
        // Wallet and provider names are brands, so they stay untranslated.
        const Wrap(
          alignment: .center,
          spacing: MonAISpacing.x2,
          runSpacing: MonAISpacing.x2,
          children: [
            MonAIPill(text: 'Cash'),
            MonAIPill(text: 'BCA'),
            MonAIPill(text: 'GoPay'),
            MonAIPill(text: 'OVO'),
            MonAIPill(text: 'DANA'),
          ],
        ),
      ],
    );
  }
}

/// Page 2: wallets stacked into one total.
class _WalletsIllustration extends StatelessWidget {
  const _WalletsIllustration();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      spacing: MonAISpacing.x2_5,
      children: [
        _WalletRow(
          monogram: 'BCA',
          monogramColor: c.primary,
          name: l10n.onboardingSampleBca,
          balance: _bcaBalance,
          indent: 0,
        ),
        _WalletRow(
          monogram: 'GP',
          monogramColor: WalletGradients.eWallet(dark: c.isDark).start,
          name: l10n.onboardingSampleGopay,
          balance: _goPayBalance,
          indent: MonAISpacing.x4,
        ),
        _WalletRow(
          monogram: 'Rp',
          monogramColor: WalletGradients.cash(dark: c.isDark).start,
          name: l10n.onboardingSampleCash,
          balance: _cashBalance,
          indent: MonAISpacing.x8,
        ),
        const Padding(
          padding: .only(top: MonAISpacing.x2),
          child: _WalletsTotal(),
        ),
      ],
    );
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({
    required this.monogram,
    required this.monogramColor,
    required this.name,
    required this.balance,
    required this.indent,
  });

  final String monogram;
  final Color monogramColor;
  final String name;
  final int balance;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelLarge;
    return Padding(
      padding: .only(left: indent),
      child: AuthIllustrationCard(
        borderRadius: MonAIRadius.lgAll,
        padding: const .symmetric(
          horizontal: MonAISpacing.x3_5,
          vertical: MonAISpacing.x3,
        ),
        child: Row(
          spacing: MonAISpacing.x3,
          children: [
            MonAIMonogram(
              text: monogram,
              containerColor: monogramColor,
              contentColor: Colors.white,
              size: _walletMonogramSize,
            ),
            Expanded(child: Text(name, style: style)),
            Text(formatRupiah(balance), style: style?.tabular),
          ],
        ),
      ),
    );
  }
}

class _WalletsTotal extends StatelessWidget {
  const _WalletsTotal();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.highlight,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x4,
          vertical: MonAISpacing.x2,
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: MonAISpacing.x2,
          children: [
            Text(
              context.l10n.onboardingSampleTotal,
              style: context.textTheme.labelMedium?.copyWith(
                color: c.onHighlight,
              ),
            ),
            Text(
              formatRupiah(_bcaBalance + _goPayBalance + _cashBalance),
              style: context.textTheme.titleMedium
                  ?.withWeight(.w700)
                  .tabular
                  .copyWith(color: c.onHighlight),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page 3: a budget nearing its limit and where the money went.
class _InsightsIllustration extends StatelessWidget {
  const _InsightsIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: MonAISpacing.x3,
      children: [
        const _BudgetCard(),
        const _BreakdownCard(),
        MonAIPill(text: context.l10n.onboardingSampleComparison),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return AuthIllustrationCard(
      borderRadius: authIllustrationCardRadius,
      child: Column(
        crossAxisAlignment: .start,
        spacing: MonAISpacing.x2_5,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.onboardingSampleBudget,
                  style: t.labelLarge,
                ),
              ),
              Text(
                '80%',
                style: t.titleMedium
                    ?.withWeight(.w700)
                    .tabular
                    .copyWith(color: c.warning),
              ),
            ],
          ),
          MonAIProgressBar(progress: 0.8, color: c.warning),
          Text(
            context.l10n.onboardingSampleBudgetLeft(formatRupiah(_budgetLeft)),
            style: t.bodySmall?.tabular.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthIllustrationCard(
      borderRadius: authIllustrationCardRadius,
      child: Column(
        crossAxisAlignment: .start,
        spacing: MonAISpacing.x2,
        children: [
          Text(
            l10n.onboardingSampleBreakdown,
            style: context.textTheme.labelLarge,
          ),
          _BreakdownRow(
            label: l10n.onboardingSampleFood,
            color: authSampleFoodColor,
            fill: 1,
            percent: 36,
          ),
          _BreakdownRow(
            label: l10n.onboardingSampleBills,
            color: _billsColor,
            fill: 0.7,
            percent: 25,
          ),
          _BreakdownRow(
            label: l10n.onboardingSampleTransport,
            color: _transportColor,
            fill: 0.48,
            percent: 17,
          ),
        ],
      ),
    );
  }
}

/// One category bar. [fill] is relative to the largest category, as in the
/// report.
class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.color,
    required this.fill,
    required this.percent,
  });

  final String label;
  final Color color;
  final double fill;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        SizedBox(
          width: _breakdownLabelWidth,
          child: Text(label, style: context.textTheme.bodySmall),
        ),
        Expanded(
          child: MonAIProgressBar(
            progress: fill,
            color: CategoryColors.content(color, dark: context.colors.isDark),
          ),
        ),
        SizedBox(
          width: _breakdownPercentWidth,
          child: Text(
            '$percent%',
            textAlign: .end,
            style: context.textTheme.labelMedium?.tabular,
          ),
        ),
      ],
    );
  }
}
