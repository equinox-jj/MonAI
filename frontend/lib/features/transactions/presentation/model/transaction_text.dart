import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';

extension TransactionTypeText on TransactionType {
  String label(AppLocalizations l10n) => switch (this) {
    .expense => l10n.transactionTypeExpense,
    .income => l10n.transactionTypeIncome,
    .transfer => l10n.transactionTypeTransfer,
  };

  MoneyDirection get direction => switch (this) {
    .expense => .expense,
    .income => .income,
    .transfer => .transfer,
  };
}

extension TransactionSourceText on TransactionSource {
  String label(AppLocalizations l10n) => switch (this) {
    .manual => l10n.transactionSourceManual,
    .quickAdd => l10n.transactionSourceQuickAdd,
    .receipt => l10n.transactionSourceReceipt,
  };

  MonAIIconData? get icon => switch (this) {
    .manual => null,
    .quickAdd || .receipt => MonAIIcons.autoAwesome,
  };
}

extension TransactionText on Transaction {
  MoneyDirection get direction => type.direction;

  String titleText(AppLocalizations l10n, TransactionLookups lookups) =>
      note ??
      merchant ??
      lookups.category(categoryId)?.name ??
      switch (type) {
        .transfer => l10n.transactionTypeTransfer,
        .expense || .income => l10n.transactionUntitled,
      };

  String get amountText => switch (type) {
    .expense => formatRupiahSigned(amount, negative: true),
    .income => formatRupiahSigned(amount, negative: false),
    .transfer => formatRupiah(amount),
  };

  String? walletText(TransactionLookups lookups) {
    final from = lookups.wallet(walletId)?.name;
    final to = lookups.wallet(toWalletId)?.name;
    return switch ((from, to)) {
      (final from?, final to?) when type == .transfer => '$from → $to',
      (final from, _) => from,
    };
  }

  String metaText(AppLocalizations l10n, TransactionLookups lookups) => [
    if (type == .transfer)
      l10n.transactionTypeTransfer
    else
      lookups.category(categoryId)?.name,
    walletText(lookups),
    MonthFormat.time(createdAt.toLocal()),
  ].nonNulls.join(' · ');

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

  MonAIIconData iconOf(TransactionLookups lookups) => type == .transfer
      ? MonAIIcons.swapHoriz
      : categoryIcon(lookups.category(categoryId)?.icon);

  Color colorOf(TransactionLookups lookups, {required Color transferColor}) =>
      type == .transfer
      ? transferColor
      : CategoryColors.parse(lookups.category(categoryId)?.color);
}

abstract final class TransactionDates {
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

  static String long(DateTime day, String locale) =>
      DateFormat('EEEE, d MMMM y', locale).format(day);

  static String shortMonthYear(DateTime month, String locale) =>
      DateFormat.yMMM(locale).format(month);

  static String monthYear(DateTime month, String locale) =>
      DateFormat.yMMMM(locale).format(month);
}
