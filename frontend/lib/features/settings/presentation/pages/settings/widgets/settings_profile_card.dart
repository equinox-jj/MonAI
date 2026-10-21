import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/presentation/pages/settings/bloc/settings_bloc.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.settingsProfileOpen,
      child: MonAICard(
        onTap: onTap,
        child: BlocSelector<SettingsBloc, SettingsState, SettingsProfile?>(
          selector: (state) => state.overview.profile,
          builder: (context, profile) => Row(
            spacing: MonAISpacing.x3_5,
            children: [
              MonAIAvatar(
                initials: profile?.initials ?? '',
                size: MonAISizes.avatarXLarge,
                imageUrl: profile?.avatarUrl,
              ),
              Expanded(
                child: switch (profile) {
                  null => const _ProfileSkeleton(),
                  final profile => _ProfileText(profile: profile),
                },
              ),
              MonAIIcon(
                MonAIIcons.chevronRight,
                color: context.colors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileText extends StatelessWidget {
  const _ProfileText({required this.profile});

  final SettingsProfile profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x0_5,
      children: [
        Row(
          spacing: MonAISpacing.x2,
          children: [
            Flexible(
              child: Text(
                profile.name,
                maxLines: 1,
                overflow: .ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  color: c.textPrimary,
                ),
              ),
            ),
            if (profile.roleBadge case final badge?) MonAITag(text: badge),
          ],
        ),
        Text(
          profile.email,
          maxLines: 1,
          overflow: .ellipsis,
          style: context.textStyles.bodyCompact.copyWith(color: c.textTertiary),
        ),
      ],
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x2,
      children: [
        FractionallySizedBox(
          widthFactor: 0.6,
          child: MonAISkeleton(height: MonAISpacing.x5),
        ),
        MonAISkeleton(height: MonAISpacing.x3_5),
      ],
    );
  }
}
