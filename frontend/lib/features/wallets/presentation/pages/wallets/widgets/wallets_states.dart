import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_actions.dart';
import 'package:monai/features/wallets/presentation/widgets/wallet_card.dart';

class WalletsSkeleton extends StatelessWidget {
  const WalletsSkeleton({super.key});

  static const _cards = 3;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.walletsLoading,
      excludeSemantics: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const .symmetric(horizontal: MonAISpacing.screenHorizontal),
        itemCount: _cards + 1,
        separatorBuilder: (_, _) => const SizedBox(height: MonAISpacing.x4),
        itemBuilder: (context, index) => MonAISkeleton(
          height: index == 0 ? 112 : walletListCardHeight,
          borderRadius: MonAIRadius.lgAll,
        ),
      ),
    );
  }
}

class WalletsLoadError extends StatelessWidget {
  const WalletsLoadError({required this.actions, super.key});

  final WalletsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child: BlocSelector<WalletsBloc, WalletsState, (WalletFailure?, bool)>(
        selector: (state) => (state.loadFailure, state.isRefreshing),
        builder: (context, selected) {
          final (failure, isRetrying) = selected;
          return MonAIStateMessage(
            icon: failure == .network ? MonAIIcons.cloudOff : MonAIIcons.error,
            tone: .error,
            title: l10n.walletsLoadErrorTitle,
            message: (failure ?? .unexpected).message(l10n),
            actionLabel: l10n.walletsRetry,
            actionIcon: MonAIIcons.refresh,
            actionLoading: isRetrying,
            onAction: actions.onRetry,
          );
        },
      ),
    );
  }
}

class WalletsEmpty extends StatelessWidget {
  const WalletsEmpty({required this.actions, super.key});

  final WalletsActions actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Centered(
      child: MonAIStateMessage(
        icon: MonAIIcons.accountBalanceWallet,
        title: l10n.walletsEmptyTitle,
        message: l10n.walletsEmptyBody,
        actionLabel: l10n.walletsAdd,
        actionIcon: MonAIIcons.add,
        onAction: actions.onAddWallet,
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child: child,
      ),
    );
  }
}
