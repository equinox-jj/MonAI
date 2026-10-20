import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_text.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_actions.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// Wallet cards in a grid row on tablet portrait.
const _gridColumns = 4;

/// The tablet grid's card height.
const _gridCardHeight = 128.0;

/// "Wallets" with its cards: a horizontal row that runs to the screen edge
/// on phones, a grid of four on tablet portrait.
///
/// The phone row pads itself, so place it without side padding.
class HomeWallets extends StatelessWidget {
  const HomeWallets({
    required this.actions,
    required this.widthClass,
    super.key,
  });

  final HomeActions actions;
  final MonAIWidthClass widthClass;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPhone = widthClass == .compact;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.sectionContentGap,
      children: [
        Padding(
          padding: .symmetric(
            horizontal: isPhone ? MonAISpacing.screenHorizontal : 0,
          ),
          child: MonAISectionHeader(
            title: l10n.homeWallets,
            actionLabel: l10n.homeSeeAll,
            onActionPressed: actions.onSeeAllWallets,
          ),
        ),
        BlocSelector<HomeBloc, HomeState, (List<Wallet>, bool)>(
          selector: (state) =>
              (state.dashboard?.wallets ?? const [], state.isBalanceHidden),
          builder: (context, selected) {
            final (wallets, isHidden) = selected;
            if (isPhone) {
              return SizedBox(
                height: MonAISizes.walletCardHeight,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  padding: const .symmetric(
                    horizontal: MonAISpacing.screenHorizontal,
                  ),
                  itemCount: wallets.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: MonAISpacing.x3),
                  itemBuilder: (context, index) => SizedBox(
                    width: MonAISizes.walletCardWidth,
                    child: _WalletCard(
                      wallet: wallets[index],
                      isHidden: isHidden,
                      onTap: actions.onOpenWallet,
                    ),
                  ),
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: .zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridColumns,
                mainAxisExtent: _gridCardHeight,
                crossAxisSpacing: MonAISpacing.x3,
                mainAxisSpacing: MonAISpacing.x3,
              ),
              itemCount: wallets.length,
              itemBuilder: (context, index) => _WalletCard(
                wallet: wallets[index],
                isHidden: isHidden,
                onTap: actions.onOpenWallet,
                compact: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.wallet,
    required this.isHidden,
    required this.onTap,
    this.compact = false,
  });

  final Wallet wallet;
  final bool isHidden;
  final ValueChanged<String> onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAIWalletCard(
      name: wallet.name,
      monogram: walletMonogram(wallet.name),
      gradient: WalletGradients.of(
        wallet.type,
        dark: context.colors.isDark,
        colorHex: wallet.color,
      ),
      balance: isHidden
          ? l10n.homeHiddenAmount
          : formatRupiah(wallet.currentBalance),
      balanceLabel: l10n.homeWalletBalance(wallet.type.label(l10n)),
      defaultLabel: wallet.isDefault && !compact
          ? l10n.homeWalletDefault
          : null,
      compact: compact,
      onTap: () => onTap(wallet.id),
    );
  }
}
