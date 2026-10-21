import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// A wallet's monogram on its card color.
class QuickAddWalletAvatar extends StatelessWidget {
  const QuickAddWalletAvatar({required this.wallet, super.key});

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

extension QuickAddCategoryOption on Category {
  /// This category in [MonAICategoryPickerSheet].
  MonAICategoryOption get pickerOption => MonAICategoryOption(
    id: id,
    name: name,
    icon: categoryIcon(icon),
    color: CategoryColors.parse(color),
  );
}

extension QuickAddWalletOption on Wallet {
  /// This wallet with its balance in [MonAIRadioPickerSheet].
  MonAIRadioPickerOption pickerOption(AppLocalizations l10n) =>
      MonAIRadioPickerOption(
        id: id,
        title: name,
        subtitle: formatRupiah(currentBalance),
        tag: isDefault ? l10n.transactionFormDefault : null,
        leading: QuickAddWalletAvatar(wallet: this),
      );
}
