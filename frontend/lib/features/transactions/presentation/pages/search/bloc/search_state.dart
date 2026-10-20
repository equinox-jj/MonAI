part of 'search_bloc.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    /// The first of the month searched on the server.
    required DateTime month,

    /// The user's current date; later months can't be picked.
    required DateTime today,

    /// [UiStatus.initial] while the text is blank (recent searches),
    /// [UiStatus.loading], [UiStatus.success] with results,
    /// [UiStatus.empty] without, or [UiStatus.failure].
    @Default(UiStatus.initial) UiStatus status,

    /// The text as typed.
    @Default('') String query,

    /// Searches every cached month on the device instead of [month].
    @Default(false) bool allMonths,
    @Default(TransactionFilter()) TransactionFilter filter,
    @Default([]) List<Transaction> results,

    /// The server page after [results]; null on the last one.
    String? nextCursor,

    /// How many cached results an all-months search shows.
    @Default(TransactionRepository.pageSize) int limit,
    @Default(false) bool isLoadingMore,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default({}) Map<DateTime, int> monthPickerTotals,

    /// The last searches, newest first.
    @Default([]) List<String> recentSearches,

    /// Why the search failed.
    TransactionFailure? failure,
  }) = _SearchState;
}

extension SearchStateX on SearchState {
  DateTime get currentMonth => monthOf(today);

  bool get hasQuery => query.normalizedSearch.isNotEmpty;

  bool get hasFilter => filter != const TransactionFilter();

  bool get hasMore => allMonths ? results.length >= limit : nextCursor != null;

  /// What the loaded results add up to: income minus expenses.
  int get net => results.fold(
    0,
    (sum, t) => switch (t.type) {
      .income => sum + t.amount,
      .expense => sum - t.amount,
      .transfer => sum,
    },
  );
}
