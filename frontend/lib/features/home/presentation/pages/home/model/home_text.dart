import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';

extension HomeGreetingText on HomeGreeting {
  String text(AppLocalizations l10n) => switch (this) {
    .morning => l10n.homeGreetingMorning,
    .afternoon => l10n.homeGreetingAfternoon,
    .evening => l10n.homeGreetingEvening,
  };
}

extension MonthSummaryText on MonthSummary {
  bool get hasTotals => incomeTotal > 0 || expenseTotal > 0;

  String? changeText(AppLocalizations l10n, String locale) {
    final change = expenseChangePercent;
    if (change == null) return null;
    final previous = MonthFormat.monthName(previousMonth, locale);
    final percent = change.abs().round();
    return switch (percent) {
      0 => l10n.homeSpentSame(previous),
      _ when change < 0 => l10n.homeSpentLess(percent, previous),
      _ => l10n.homeSpentMore(percent, previous),
    };
  }
}

extension SpendingSliceText on SpendingSlice {
  String label(AppLocalizations l10n) =>
      isOthers ? l10n.homeSpendingOthers : name ?? '';

  int get percent => sharePercent.round();
}

extension RecentTransactionText on RecentTransaction {
  MoneyDirection get direction => switch (type) {
    .expense => .expense,
    .income => .income,
    .transfer => .transfer,
  };

  String titleText(AppLocalizations l10n) =>
      title ??
      switch (type) {
        .transfer => l10n.homeTransactionTransfer,
        .expense || .income => l10n.homeTransactionUntitled,
      };

  String get amountText => switch (type) {
    .expense => formatRupiahSigned(amount, negative: true),
    .income => formatRupiahSigned(amount, negative: false),
    .transfer => formatRupiah(amount),
  };

  String metaText(AppLocalizations l10n, String locale) {
    final isTransfer = type == .transfer;
    final wallets = switch ((walletName, toWalletName)) {
      (final from?, final to?) when isTransfer => '$from → $to',
      (final from, _) => from,
    };
    final dayText = switch (day) {
      RecentToday(:final time) => MonthFormat.time(time),
      RecentYesterday() => l10n.homeYesterday,
      RecentEarlier(:final date) => MonthFormat.dayMonth(date, locale),
    };
    return [
      if (isTransfer) l10n.homeTransactionTransfer else categoryName,
      wallets,
      dayText,
    ].nonNulls.join(' · ');
  }
}
