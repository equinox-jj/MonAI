import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

part 'home_dashboard.freezed.dart';

enum HomeGreeting { morning, afternoon, evening }

@freezed
abstract class HomeDashboard with _$HomeDashboard {
  const factory HomeDashboard({
    required DateTime month,
    required HomeGreeting greeting,
    required String userName,
    required String initials,

    /// Whether a user or any wallet is cached, so there is something to show
    /// while a refresh runs.
    required bool hasCache,
    required int totalBalance,
    required List<Wallet> wallets,

    /// Days after today until the month ends; 0 on its last day.
    required int daysLeftInMonth,

    /// At most [kMaxSpendingSlices], largest first; the last may be
    /// "Others".
    required List<SpendingSlice> spending,
    required List<RecentTransaction> recent,
    String? avatarUrl,
    MonthSummary? summary,
    Budget? budget,
  }) = _HomeDashboard;
}

@freezed
abstract class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    required int incomeTotal,
    required int expenseTotal,
    required DateTime previousMonth,

    /// Against [previousMonth]; negative means less was spent. Null when
    /// that month had no expenses.
    double? expenseChangePercent,
  }) = _MonthSummary;
}

@freezed
abstract class SpendingSlice with _$SpendingSlice {
  const factory SpendingSlice({
    required int amount,
    required double sharePercent,

    /// Null for the "Others" slice.
    String? categoryId,
    String? name,

    /// `#RRGGBB`; null uses the neutral color.
    String? color,
  }) = _SpendingSlice;

  const SpendingSlice._();

  bool get isOthers => categoryId == null;
}

@freezed
abstract class RecentTransaction with _$RecentTransaction {
  const factory RecentTransaction({
    required String id,
    required TransactionType type,
    required int amount,
    required RecentDay day,

    /// The note, else the merchant, else the category name; null when there
    /// is none, so the screen labels it by its [type].
    String? title,
    String? categoryName,
    String? icon,
    String? color,
    String? walletName,
    String? toWalletName,
  }) = _RecentTransaction;
}

@freezed
sealed class RecentDay with _$RecentDay {
  /// Today; [time] is when it was recorded, the closest thing to a time the
  /// API has.
  const factory RecentDay.today(DateTime time) = RecentToday;
  const factory RecentDay.yesterday() = RecentYesterday;
  const factory RecentDay.earlier(DateTime date) = RecentEarlier;
}
