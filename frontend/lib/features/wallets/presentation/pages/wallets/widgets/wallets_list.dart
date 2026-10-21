import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_actions.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_total_card.dart';
import 'package:monai/features/wallets/presentation/widgets/wallet_card.dart';

/// The total card, a card per wallet and the archived wallets' button.
/// [showSelection] rings the wallet shown beside the list.
class WalletsListSliver extends StatelessWidget {
  const WalletsListSliver({
    required this.actions,
    required this.showSelection,
    super.key,
  });

  final WalletsActions actions;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .fromLTRB(
        MonAISpacing.screenHorizontal,
        0,
        MonAISpacing.screenHorizontal,
        MonAISpacing.x6,
      ),
      sliver: BlocSelector<WalletsBloc, WalletsState, (List<Wallet>, String?)>(
        selector: (state) =>
            (state.wallets, showSelection ? state.shownId : null),
        builder: (context, selected) {
          final (wallets, selectedId) = selected;
          // The total card, the wallets, then the archived button.
          return SliverList.separated(
            itemCount: wallets.length + 2,
            separatorBuilder: (_, _) => const SizedBox(height: MonAISpacing.x4),
            itemBuilder: (context, index) {
              if (index == 0) return const WalletsTotalCard();
              if (index == wallets.length + 1) {
                return _ArchivedButton(onTap: actions.onShowArchived);
              }
              final wallet = wallets[index - 1];
              return _SelectableCard(
                selected: wallet.id == selectedId,
                child: SizedBox(
                  height: walletListCardHeight,
                  child: WalletCard(
                    wallet: wallet,
                    onTap: () => actions.onOpenWallet(wallet.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Rings the wallet shown beside the list.
class _SelectableCard extends StatelessWidget {
  const _SelectableCard({required this.selected, required this.child});

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!selected) return child;
    return Semantics(
      selected: true,
      child: DecoratedBox(
        position: .foreground,
        decoration: BoxDecoration(
          borderRadius: MonAIRadius.lgAll,
          border: Border.all(
            color: context.colors.accent,
            width: MonAISizes.borderFocused,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// "Show N archived wallets"; nothing while none are archived.
class _ArchivedButton extends StatelessWidget {
  const _ArchivedButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BlocSelector<WalletsBloc, WalletsState, int>(
      selector: (state) => state.archivedCount,
      builder: (context, count) {
        if (count == 0) return const SizedBox.shrink();
        return SizedBox(
          height: MonAISizes.buttonMedium,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: MonAIRadius.mdAll,
              side: BorderSide(color: c.borderStrong),
            ),
            clipBehavior: .antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: .center,
                spacing: MonAISpacing.x1_5,
                children: [
                  MonAIIcon(
                    MonAIIcons.inventory2,
                    size: MonAISizes.iconLg,
                    color: c.textSecondary,
                  ),
                  Text(
                    context.l10n.walletsShowArchived(count),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
