import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

// Display text for the wallets screens. Day and month names follow the
// app's locale.

extension WalletText on Wallet {
  /// "Bank · Rp 3.065.000", for the archived list.
  String typeAndBalanceText(AppLocalizations l10n) =>
      '${type.label(l10n)} · ${formatRupiah(currentBalance)}';
}

/// A transaction as a wallet's "This month" list shows it, seen from
/// [walletId].
extension WalletTransactionText on Transaction {
  /// The note, merchant or category; else "Transfer" or "Transaction".
  String titleIn(AppLocalizations l10n, Map<String, Category> categories) =>
      note ??
      merchant ??
      categories[categoryId]?.name ??
      switch (type) {
        .transfer => l10n.walletDetailTransfer,
        .expense || .income => l10n.walletDetailUntitled,
      };

  /// `Shopping · 9 Oct`, or `Transfer to GoPay · 9 Oct` from this wallet
  /// and `Transfer from BCA · 9 Oct` into it.
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

  /// `−Rp 35.000` / `+Rp 8.500.000`; a transfer is signed by whether it
  /// leaves [walletId].
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

  /// The category's icon, or the transfer icon.
  MonAIIconData iconIn(Map<String, Category> categories) => type == .transfer
      ? MonAIIcons.swapHoriz
      : categoryIcon(categories[categoryId]?.icon);

  /// The category's color; [transferColor] for a transfer.
  Color colorIn(
    Map<String, Category> categories, {
    required Color transferColor,
  }) => type == .transfer
      ? transferColor
      : CategoryColors.parse(categories[categoryId]?.color);
}
