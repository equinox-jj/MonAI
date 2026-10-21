import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

extension WalletText on Wallet {
  String typeAndBalanceText(AppLocalizations l10n) =>
      '${type.label(l10n)} · ${formatRupiah(currentBalance)}';
}

extension WalletTransactionText on Transaction {
  String titleIn(AppLocalizations l10n, Map<String, Category> categories) =>
      note ??
      merchant ??
      categories[categoryId]?.name ??
      switch (type) {
        .transfer => l10n.walletDetailTransfer,
        .expense || .income => l10n.walletDetailUntitled,
      };

  String metaIn(
    AppLocalizations l10n, {
    required String walletId,
    required Map<String, Category> categories,
    required Map<String, Wallet> wallets,
    required String locale,
  }) {
    final day = DateFormat('d MMM', locale).format(date);
    final what = switch (type) {
      .transfer when walletId == this.walletId =>
        switch (wallets[toWalletId]?.name) {
          final to? => l10n.walletDetailTransferTo(to),
          null => l10n.walletDetailTransfer,
        },
      .transfer => switch (wallets[this.walletId]?.name) {
        final from? => l10n.walletDetailTransferFrom(from),
        null => l10n.walletDetailTransfer,
      },
      .expense || .income => categories[categoryId]?.name,
    };
    return [what, day].nonNulls.join(' · ');
  }

  String amountIn(String walletId) => switch (type) {
    .expense => formatRupiahSigned(amount, negative: true),
    .income => formatRupiahSigned(amount, negative: false),
    .transfer => formatRupiahSigned(
      amount,
      negative: walletId == this.walletId,
    ),
  };

  MoneyDirection get direction => switch (type) {
    .expense => .expense,
    .income => .income,
    .transfer => .transfer,
  };

  MonAIIconData iconIn(Map<String, Category> categories) => type == .transfer
      ? MonAIIcons.swapHoriz
      : categoryIcon(categories[categoryId]?.icon);

  Color colorIn(
    Map<String, Category> categories, {
    required Color transferColor,
  }) => type == .transfer
      ? transferColor
      : CategoryColors.parse(categories[categoryId]?.color);
}
