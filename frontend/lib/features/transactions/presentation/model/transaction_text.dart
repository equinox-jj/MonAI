import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';

// Display text for transactions, shared by the transactions screens. Day and
// month names follow the app's locale.

extension TransactionTypeText on TransactionType {
  /// "Expense", "Income", "Transfer".
  String label(AppLocalizations l10n) => switch (this) {
    .expense => l10n.transactionTypeExpense,
    .income => l10n.transactionTypeIncome,
    .transfer => l10n.transactionTypeTransfer,
  };

  /// Colors an amount and picks its arrow.
  MoneyDirection get direction => switch (this) {
    .expense => .expense,
    .income => .income,
    .transfer => .transfer,
  };
}

extension TransactionSourceText on TransactionSource {
  /// "Manual entry", "AI quick add", "Receipt scan".
  String label(AppLocalizations l10n) => switch (this) {
    .manual => l10n.transactionSourceManual,
    .quickAdd => l10n.transactionSourceQuickAdd,
    .receipt => l10n.transactionSourceReceipt,
  };

  /// The sparkle for what AI drafted; none for manual entry.
  MonAIIconData? get icon => switch (this) {
    .manual => null,
    .quickAdd || .receipt => MonAIIcons.autoAwesome,
  };
}

extension TransactionText on Transaction {
  /// Colors the amount and picks its arrow.
  MoneyDirection get direction => type.direction;

  /// The note, merchant or category; else "Transfer" or "Transaction".
  String titleText(AppLocalizations l10n, TransactionLookups lookups) =>
      note ??
      merchant ??
      lookups.category(categoryId)?.name ??
      switch (type) {
        .transfer => l10n.transactionTypeTransfer,
        .expense || .income => l10n.transactionUntitled,
      };

  /// `−Rp 35.000` / `+Rp 8.500.000` / `Rp 500.000`.
  String get amountText => switch (type) {
    .expense => formatRupiahSigned(amount, negative: true),
    .income => formatRupiahSigned(amount, negative: false),
    .transfer => formatRupiah(amount),
  };

  /// "BCA → GoPay" for a transfer, else the wallet; null when unknown.
  String? walletText(TransactionLookups lookups) {
    final from = lookups.wallet(walletId)?.name;
    final to = lookups.wallet(toWalletId)?.name;
    return switch ((from, to)) {
      (final from?, final to?) when type == .transfer => '$from → $to',
      (final from, _) => from,
    };
  }

  /// `Food · GoPay · 12:40`, or `Transfer · BCA → GoPay · 19:20`; the time
  /// is when it was recorded. Unknown names are left out.
  String metaText(AppLocalizations l10n, TransactionLookups lookups) => [
    if (type == .transfer)
      l10n.transactionTypeTransfer
    else
      lookups.category(categoryId)?.name,
    walletText(lookups),
    MonthFormat.time(createdAt.toLocal()),
  ].nonNulls.join(' · ');

  /// `Food · Cash · 10 Oct`: [metaText] with the day instead of the time,
  /// for results from many days.
  String datedMetaText(
    AppLocalizations l10n,
    TransactionLookups lookups,
    String locale,
  ) => [
    if (type == .transfer)
      l10n.transactionTypeTransfer
    else
      lookups.category(categoryId)?.name,
    walletText(lookups),
    MonthFormat.dayMonth(date, locale),
  ].nonNulls.join(' · ');

  /// The category's icon, or the transfer icon.
  MonAIIconData iconOf(TransactionLookups lookups) => type == .transfer
      ? MonAIIcons.swapHoriz
      : categoryIcon(lookups.category(categoryId)?.icon);

  /// The category's color; [transferColor] for a transfer.
  Color colorOf(TransactionLookups lookups, {required Color transferColor}) =>
      type == .transfer
      ? transferColor
      : CategoryColors.parse(lookups.category(categoryId)?.color);
}

/// Day headers and dates of the transaction lists.
abstract final class TransactionDates {
  /// `Today · Sat, 10 Oct`, `Yesterday · Fri, 9 Oct`, `Thu, 8 Oct`, and
  /// `Thu, 8 Oct 2025` outside [today]'s year.
  static String dayHeader(
    DateTime day,
    DateTime today,
    AppLocalizations l10n,
    String locale,
  ) {
    final date = DateTime(today.year, today.month, today.day);
    final short = DateFormat('EEE, d MMM', locale).format(day);
    if (day == date) return l10n.transactionsDayToday(short);
    if (day == DateTime(date.year, date.month, date.day - 1)) {
      return l10n.transactionsDayYesterday(short);
    }
    if (day.year == date.year) return short;
    return DateFormat('EEE, d MMM y', locale).format(day);
  }

  /// `Today, 10 Oct`, `Yesterday, 9 Oct`, else `Thu, 8 Oct 2026`.
  static String field(
    DateTime day,
    DateTime today,
    AppLocalizations l10n,
    String locale,
  ) {
    final date = DateTime(today.year, today.month, today.day);
    final short = DateFormat('d MMM', locale).format(day);
    if (day == date) return l10n.transactionFormTodayDate(short);
    if (day == DateTime(date.year, date.month, date.day - 1)) {
      return l10n.transactionFormYesterdayDate(short);
    }
    return DateFormat('EEE, d MMM y', locale).format(day);
  }

  /// `Saturday, 10 October 2026`.
  static String long(DateTime day, String locale) =>
      DateFormat('EEEE, d MMMM y', locale).format(day);

  /// `Oct 2026`.
  static String shortMonthYear(DateTime month, String locale) =>
      DateFormat.yMMM(locale).format(month);

  /// `October 2026`.
  static String monthYear(DateTime month, String locale) =>
      DateFormat.yMMMM(locale).format(month);
}
