import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

const walletListCardHeight = 124.0;

class WalletCard extends StatelessWidget {
  const WalletCard({
    required this.wallet,
    super.key,
    this.colorHex,
    this.balance,
    this.showType = true,
    this.onTap,
  });

  final Wallet wallet;
  final String? colorHex;
  final int? balance;
  final bool showType;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAIWalletCard(
      name: wallet.name,
      monogram: walletMonogram(wallet.name),
      gradient: WalletGradients.of(
        wallet.type,
        dark: context.colors.isDark,
        colorHex: colorHex ?? wallet.color,
      ),
      balance: formatRupiah(balance ?? wallet.currentBalance),
      balanceLabel: showType ? wallet.type.label(l10n) : null,
      defaultLabel: wallet.isDefault ? l10n.walletsDefault : null,
      onTap: onTap,
    );
  }
}
