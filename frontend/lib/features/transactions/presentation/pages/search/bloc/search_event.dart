part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  /// The screen opened.
  const factory SearchEvent.started() = _Started;

  /// The search text changed; searched once typing pauses.
  const factory SearchEvent.queryChanged(String query) = _QueryChanged;

  /// The keyboard's search key: remembers the text in recent searches.
  const factory SearchEvent.submitted() = _Submitted;

  /// A recent search was tapped.
  const factory SearchEvent.recentUsed(String query) = _RecentUsed;

  /// "Search all months" (true) searches every cached month on the device,
  /// offline too; false goes back to the one month on the server.
  const factory SearchEvent.allMonthsToggled({required bool allMonths}) =
      _AllMonthsToggled;

  /// [month] is the first of the month.
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

  /// The results scrolled near their end.
  const factory SearchEvent.loadMoreRequested() = _LoadMoreRequested;

  /// "Try again" on the error.
  const factory SearchEvent.retried() = _Retried;

  /// The cached results changed. Sent by the bloc itself.
  const factory SearchEvent.cachedResultsChanged(List<Transaction> results) =
      _CachedResultsChanged;

  /// The cached categories or wallets changed. Sent by the bloc itself.
  const factory SearchEvent.lookupsChanged(TransactionLookups lookups) =
      _LookupsChanged;

  /// The month picker's cached totals changed. Sent by the bloc itself.
  const factory SearchEvent.expenseTotalsChanged(Map<DateTime, int> totals) =
      _ExpenseTotalsChanged;
}
