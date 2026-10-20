import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

part 'home_dashboard.freezed.dart';

/// The time of day the greeting is picked from.
enum HomeGreeting { morning, afternoon, evening }

/// Everything Home shows for [month], built from the cache.
@freezed
abstract class HomeDashboard with _$HomeDashboard {
  const factory HomeDashboard({
    /// The first of the month the summary, budget, spending and recent
    /// sections cover.
    required DateTime month,
    required HomeGreeting greeting,

    /// Empty until the user is cached.
    required String userName,
    required String initials,

    /// Whether a user or any wallet is cached, so there is something to show
    /// while a refresh runs.
    required bool hasCache,

    /// Rupiah across wallets that are not archived.
    required int totalBalance,

    /// Not archived, default first.
    required List<Wallet> wallets,

    /// Days after today until the month ends; 0 on its last day.
    required int daysLeftInMonth,

    /// At most [kMaxSpendingSlices], largest first; the last may be
    /// "Others".
    required List<SpendingSlice> spending,

    /// The month's newest transactions, newest first.
    required List<RecentTransaction> recent,
    String? avatarUrl,

    /// Null until the month's report is cached.
    MonthSummary? summary,

    /// Null when the month has no budget, or it isn't cached yet.
    Budget? budget,
  }) = _HomeDashboard;
}

/// A month's totals. Amounts are rupiah.
@freezed
abstract class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    required int incomeTotal,
    required int expenseTotal,

    /// The first of the month before.
    required DateTime previousMonth,

    /// Against [previousMonth]; negative means less was spent. Null when
    /// that month had no expenses.
    double? expenseChangePercent,
  }) = _MonthSummary;
}

/// One category's share of the month's expenses.
@freezed
abstract class SpendingSlice with _$SpendingSlice {
  const factory SpendingSlice({
    required int amount,
    required double sharePercent,

    /// Null for the "Others" slice.
    String? categoryId,

    /// Null for the "Others" slice.
    String? name,

    /// `#RRGGBB`; null uses the neutral color.
    String? color,
  }) = _SpendingSlice;

  const SpendingSlice._();

  /// Whether this slice folds the smaller categories together.
  bool get isOthers => categoryId == null;
}

/// A row of the recent list, joined with its category and wallets. Names are
/// null when they aren't cached.
@freezed
abstract class RecentTransaction with _$RecentTransaction {
  const factory RecentTransaction({
    required String id,
    required TransactionType type,

    /// Rupiah, positive; [type] gives the sign.
    required int amount,
    required RecentDay day,

    /// The note, else the merchant, else the category name; null when there
    /// is none, so the screen labels it by its [type].
    String? title,
    String? categoryName,
    String? icon,

    /// `#RRGGBB`.
    String? color,
    String? walletName,
    String? toWalletName,
  }) = _RecentTransaction;
}

/// When a recent transaction happened, relative to today.
@freezed
sealed class RecentDay with _$RecentDay {
  /// Today; [time] is when it was recorded, the closest thing to a time the
  /// API has.
  const factory RecentDay.today(DateTime time) = RecentToday;

  /// Yesterday.
  const factory RecentDay.yesterday() = RecentYesterday;

  /// Before yesterday, on [date].
  const factory RecentDay.earlier(DateTime date) = RecentEarlier;
}
