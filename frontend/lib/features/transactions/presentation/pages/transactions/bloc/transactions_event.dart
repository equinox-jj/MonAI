part of 'transactions_bloc.dart';

@freezed
sealed class TransactionsEvent with _$TransactionsEvent {
  const factory TransactionsEvent.started() = _Started;
  const factory TransactionsEvent.refreshed() = _Refreshed;

  const factory TransactionsEvent.previousMonthPressed() =
      _PreviousMonthPressed;

  const factory TransactionsEvent.nextMonthPressed() = _NextMonthPressed;
  const factory TransactionsEvent.monthPicked(DateTime month) = _MonthPicked;

  const factory TransactionsEvent.monthPickerYearShown(int year) =
      _MonthPickerYearShown;

  const factory TransactionsEvent.walletFilterPicked(String? walletId) =
      _WalletFilterPicked;

  const factory TransactionsEvent.categoryFilterPicked(String? categoryId) =
      _CategoryFilterPicked;

  const factory TransactionsEvent.typeFilterPicked(TransactionType? type) =
      _TypeFilterPicked;

  const factory TransactionsEvent.filtersCleared() = _FiltersCleared;
  const factory TransactionsEvent.loadMoreRequested() = _LoadMoreRequested;
  const factory TransactionsEvent.selected(String? id) = _Selected;
  const factory TransactionsEvent.deleteRequested(String id) = _DeleteRequested;

  const factory TransactionsEvent.transactionsChanged(
    List<Transaction> transactions,
  ) = _TransactionsChanged;

  const factory TransactionsEvent.dailyNetsChanged(Map<DateTime, int> nets) =
      _DailyNetsChanged;

  const factory TransactionsEvent.reportChanged(MonthlyReport? report) =
      _ReportChanged;

  const factory TransactionsEvent.lookupsChanged(TransactionLookups lookups) =
      _LookupsChanged;

  const factory TransactionsEvent.expenseTotalsChanged(
    Map<DateTime, int> totals,
  ) = _ExpenseTotalsChanged;
}
