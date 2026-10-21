import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

class TransactionWalletAvatar extends StatelessWidget {
  const TransactionWalletAvatar({required this.wallet, super.key});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final gradient = WalletGradients.of(
      wallet.type,
      dark: context.colors.isDark,
      colorHex: wallet.color,
    );
    return MonAIMonogram(
      text: walletMonogram(wallet.name),
      containerColor: gradient.start,
      contentColor: Colors.white,
    );
  }
}
