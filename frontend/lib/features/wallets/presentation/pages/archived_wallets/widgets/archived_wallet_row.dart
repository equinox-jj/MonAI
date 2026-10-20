import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/model/wallet_text.dart';
import 'package:monai/features/wallets/presentation/widgets/wallet_logo.dart';

/// An archived wallet: grey monogram, name, type and balance, "Unarchive".
class ArchivedWalletRow extends StatelessWidget {
  const ArchivedWalletRow({
    required this.wallet,
    required this.isRestoring,
    required this.onUnarchive,
    super.key,
    this.showDivider = true,
  });

  final Wallet wallet;
  final bool isRestoring;
  final VoidCallback onUnarchive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAIListItem(
      title: wallet.name,
      supporting: wallet.typeAndBalanceText(l10n),
      showDivider: showDivider,
      leading: WalletLogo(name: wallet.name, logoUrl: wallet.logoUrl),
      trailing: MonAIButton(
        label: l10n.archivedWalletsUnarchive,
        leadingIcon: MonAIIcons.unarchive,
        variant: .tonal,
        size: .small,
        loading: isRestoring,
        onPressed: onUnarchive,
      ),
    );
  }
}
