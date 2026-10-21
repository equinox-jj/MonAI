import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';

class WalletDetailHero extends StatelessWidget {
  const WalletDetailHero({super.key});

  static const _height = 176.0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WalletDetailBloc, WalletDetailState, Wallet?>(
      selector: (state) => state.wallet,
      builder: (context, wallet) => switch (wallet) {
        final wallet? => _Hero(wallet: wallet),
        null => const SizedBox(height: _height),
      },
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.textTheme;
    final gradient = WalletGradients.of(
      wallet.type,
      dark: context.colors.isDark,
      colorHex: wallet.color,
    );
    return SizedBox(
      height: WalletDetailHero._height,
      child: MonAIGradientCard(
        gradient: gradient.gradient,
        borderRadius: MonAIRadius.lgAll,
        padding: const .all(MonAISpacing.x4),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: MonAISpacing.x2_5,
              children: [
                MonAIMonogram(
                  text: walletMonogram(wallet.name),
                  contentColor: gradient.start,
                  size: 36,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        wallet.name,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: t.titleMedium?.copyWith(color: Colors.white),
                      ),
                      Text(
                        wallet.type.label(l10n),
                        style: t.bodySmall?.copyWith(color: gradient.muted),
                      ),
                    ],
                  ),
                ),
                if (wallet.isDefault) MonAIPill(text: l10n.walletsDefault),
              ],
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.walletDetailCurrentBalance,
                  style: t.bodySmall?.copyWith(color: gradient.muted),
                ),
                Text(
                  formatRupiah(wallet.currentBalance),
                  maxLines: 1,
                  style: context.textStyles.amountLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
