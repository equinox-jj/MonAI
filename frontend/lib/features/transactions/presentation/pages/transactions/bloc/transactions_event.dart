part of 'transactions_bloc.dart';

@freezed
sealed class TransactionsEvent with _$TransactionsEvent {
  /// The screen opened.
  const factory TransactionsEvent.started() = _Started;

  /// Pull-to-refresh, or "Try again" on the error.
  const factory TransactionsEvent.refreshed() = _Refreshed;

  const factory TransactionsEvent.previousMonthPressed() =
      _PreviousMonthPressed;

  const factory TransactionsEvent.nextMonthPressed() = _NextMonthPressed;

  /// Picked in the month picker; [month] is the first of the month.
  const factory TransactionsEvent.monthPicked(DateTime month) = _MonthPicked;

  /// The month picker shows [year], so its totals are needed.
  const factory TransactionsEvent.monthPickerYearShown(int year) =
      _MonthPickerYearShown;

  /// Null shows every wallet.
  const factory TransactionsEvent.walletFilterPicked(String? walletId) =
      _WalletFilterPicked;

  /// Null shows every category.
  const factory TransactionsEvent.categoryFilterPicked(String? categoryId) =
      _CategoryFilterPicked;

  /// Null shows every type.
  const factory TransactionsEvent.typeFilterPicked(TransactionType? type) =
      _TypeFilterPicked;

  /// "All types" or "Clear filters": drops every filter but the month.
  const factory TransactionsEvent.filtersCleared() = _FiltersCleared;

  /// The list scrolled near its end.
  const factory TransactionsEvent.loadMoreRequested() = _LoadMoreRequested;

  /// A row was tapped on a wide screen: shows it in the detail pane.
  const factory TransactionsEvent.selected(String? id) = _Selected;

  /// A row was swiped away; the app shell offers the undo.
  const factory TransactionsEvent.deleteRequested(String id) = _DeleteRequested;

  /// The cached rows changed. Sent by the bloc itself.
  const factory TransactionsEvent.transactionsChanged(
    List<Transaction> transactions,
  ) = _TransactionsChanged;

  /// The cached day totals changed. Sent by the bloc itself.
  const factory TransactionsEvent.dailyNetsChanged(Map<DateTime, int> nets) =
      _DailyNetsChanged;

  /// The month's cached report changed. Sent by the bloc itself.
  const factory TransactionsEvent.reportChanged(MonthlyReport? report) =
      _ReportChanged;

  /// The cached categories or wallets changed. Sent by the bloc itself.
  const factory TransactionsEvent.lookupsChanged(TransactionLookups lookups) =
      _LookupsChanged;

  /// The month picker's cached totals changed. Sent by the bloc itself.
  const factory TransactionsEvent.expenseTotalsChanged(
    Map<DateTime, int> totals,
  ) = _ExpenseTotalsChanged;
}
