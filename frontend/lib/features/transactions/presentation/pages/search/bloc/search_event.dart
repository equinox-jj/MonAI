part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.started() = _Started;
  const factory SearchEvent.queryChanged(String query) = _QueryChanged;
  const factory SearchEvent.submitted() = _Submitted;
  const factory SearchEvent.recentUsed(String query) = _RecentUsed;

  const factory SearchEvent.allMonthsToggled({required bool allMonths}) =
      _AllMonthsToggled;

  const factory SearchEvent.monthPicked(DateTime month) = _MonthPicked;

  const factory SearchEvent.monthPickerYearShown(int year) =
      _MonthPickerYearShown;

  const factory SearchEvent.walletFilterPicked(String? walletId) =
      _WalletFilterPicked;

  const factory SearchEvent.categoryFilterPicked(String? categoryId) =
      _CategoryFilterPicked;

  const factory SearchEvent.typeFilterPicked(TransactionType? type) =
      _TypeFilterPicked;

  const factory SearchEvent.filtersCleared() = _FiltersCleared;
  const factory SearchEvent.loadMoreRequested() = _LoadMoreRequested;
  const factory SearchEvent.retried() = _Retried;

  const factory SearchEvent.cachedResultsChanged(List<Transaction> results) =
      _CachedResultsChanged;

  const factory SearchEvent.lookupsChanged(TransactionLookups lookups) =
      _LookupsChanged;

  const factory SearchEvent.expenseTotalsChanged(Map<DateTime, int> totals) =
      _ExpenseTotalsChanged;
}
