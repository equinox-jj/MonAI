import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_text.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_actions.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_quick_add.dart';

typedef _Header = ({
  HomeGreeting greeting,
  String userName,
  String initials,
  String? avatarUrl,
  bool isFirstRun,
});

/// Greeting and name, then the avatar that opens Settings.
///
/// Phones add search (left out while there's nothing to search); tablets put
/// the quick-add bar in the header instead.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.actions,
    required this.widthClass,
    super.key,
  });

  final HomeActions actions;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, _Header>(
      selector: (state) => (
        greeting: state.dashboard?.greeting ?? .morning,
        userName: state.dashboard?.userName ?? '',
        initials: state.dashboard?.initials ?? '',
        avatarUrl: state.dashboard?.avatarUrl,
        isFirstRun: state.isFirstRun,
      ),
      builder: (context, header) {
        final l10n = context.l10n;
        final isPhone = widthClass == .compact;
        final greeting = _Greeting(
          greeting: header.isFirstRun
              ? l10n.homeGreetingWelcome
              : header.greeting.text(l10n),
          userName: header.userName,
          large: !isPhone,
        );
        final avatar = Semantics(
          button: true,
          label: l10n.homeProfile,
          excludeSemantics: true,
          child: InkWell(
            onTap: actions.onProfile,
            customBorder: const CircleBorder(),
            child: MonAIAvatar(
              initials: header.initials,
              imageUrl: header.avatarUrl,
              size: isPhone ? MonAISizes.avatarLarge : MonAISizes.buttonMedium,
            ),
          ),
        );
        final quickAdd = HomeQuickAddBar(
          onQuickAdd: actions.onQuickAdd,
          onScanReceipt: actions.onScanReceipt,
          height: widthClass == .expanded
              ? MonAISizes.buttonMedium
              : MonAISizes.quickAddField,
        );
        return Row(
          spacing: isPhone ? MonAISpacing.x3 : MonAISpacing.x4,
          children: [
            switch (widthClass) {
              .compact => Expanded(child: greeting),
              .medium || .expanded => greeting,
            },
            if (widthClass == .medium) Expanded(child: quickAdd),
            if (widthClass == .expanded) ...[
              const Spacer(),
              SizedBox(width: _expandedQuickAddWidth, child: quickAdd),
            ],
            if (isPhone && !header.isFirstRun)
              MonAIIconButton(
                icon: MonAIIcons.search,
                tooltip: l10n.homeSearch,
                onPressed: actions.onSearch,
                style: .surface,
              ),
            avatar,
          ],
        );
      },
    );
  }
}

/// The quick-add bar's width in the tablet-landscape header.
const _expandedQuickAddWidth = 400.0;

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.greeting,
    required this.userName,
    required this.large,
  });

  final String greeting;
  final String userName;

  /// The tablet header's bigger name.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.textTheme;
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(greeting, style: t.bodyMedium?.copyWith(color: c.textSecondary)),
        Text(
          userName,
          maxLines: 1,
          overflow: .ellipsis,
          style: (large ? t.headlineLarge : t.headlineSmall)?.copyWith(
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}
