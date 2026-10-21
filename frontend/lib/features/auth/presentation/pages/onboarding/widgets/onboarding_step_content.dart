import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/model/onboarding_step.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/widgets/onboarding_hero.dart';

/// One page: the illustration, then the title and body.
class OnboardingStepContent extends StatelessWidget {
  const OnboardingStepContent({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final (title, body) = switch (step) {
      .capture => (l10n.onboardingCaptureTitle, l10n.onboardingCaptureBody),
      .wallets => (l10n.onboardingWalletsTitle, l10n.onboardingWalletsBody),
      .insights => (l10n.onboardingInsightsTitle, l10n.onboardingInsightsBody),
    };
    return Padding(
      padding: const .only(
        left: MonAISpacing.screenHorizontalWide,
        right: MonAISpacing.screenHorizontalWide,
        top: MonAISpacing.x6,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x6,
        children: [
          Expanded(child: OnboardingHero(step: step)),
          Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x2_5,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: context.textTheme.displaySmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
              Text(
                body,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
