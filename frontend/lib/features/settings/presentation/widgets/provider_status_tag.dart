import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';

/// The System, Active or Inactive badge of a provider.
class ProviderStatusTag extends StatelessWidget {
  const ProviderStatusTag({required this.status, super.key});

  final ProviderStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return switch (status) {
      .system => MonAITag(text: l10n.providersBadgeSystem),
      .active => MonAITag(
        text: l10n.providersBadgeActive,
        containerColor: c.incomeContainer,
        contentColor: c.successText,
      ),
      .inactive => MonAITag(
        text: l10n.providersBadgeInactive,
        containerColor: c.surfaceSunken,
        contentColor: c.textSecondary,
      ),
    };
  }
}
