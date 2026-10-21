part of 'search_bloc.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    required DateTime month,
    required DateTime today,
    @Default(UiStatus.initial) UiStatus status,
    @Default('') String query,
    @Default(false) bool allMonths,
    @Default(TransactionFilter()) TransactionFilter filter,
    @Default([]) List<Transaction> results,
    String? nextCursor,
    @Default(TransactionRepository.pageSize) int limit,
    @Default(false) bool isLoadingMore,
    @Default(TransactionLookups()) TransactionLookups lookups,
    @Default({}) Map<DateTime, int> monthPickerTotals,
    @Default([]) List<String> recentSearches,
    TransactionFailure? failure,
  }) = _SearchState;
}
