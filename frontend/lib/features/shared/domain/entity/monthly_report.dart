import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report.freezed.dart';

/// Transfers are left out.
@freezed
abstract class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    /// The first of the month.
    required DateTime month,
    required int incomeTotal,
    required int expenseTotal,
    required int net,
    required PreviousMonthTotals previous,

    /// Expenses by category, largest first.
    required List<CategoryBreakdown> categories,

    /// Null when the previous month had no expenses.
    double? expenseChangePercent,
  }) = _MonthlyReport;
}

@freezed
abstract class PreviousMonthTotals with _$PreviousMonthTotals {
  const factory PreviousMonthTotals({
    required DateTime month,
    required int incomeTotal,
    required int expenseTotal,
  }) = _PreviousMonthTotals;
}

@freezed
abstract class CategoryBreakdown with _$CategoryBreakdown {
  const factory CategoryBreakdown({
    required String categoryId,
    required String name,
    required int amount,
    required double sharePercent,
    required int previousAmount,
    String? icon,
    String? color,

    /// Null when the category had no expenses the previous month.
    double? changePercent,
  }) = _CategoryBreakdown;
}
