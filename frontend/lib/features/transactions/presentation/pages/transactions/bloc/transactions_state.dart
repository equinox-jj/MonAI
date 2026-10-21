part of 'transactions_bloc.dart';

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    required DateTime month,
    required DateTime today,
    @Default(UiStatus.initial) UiStatus status,
    @Default(TransactionFilter()) TransactionFilter filter,
    @Default([]) List<Transaction> transactions,

    /// Hidden until the cache drops them.
    @Default({}) Set<String> deletingIds,
    @Default({}) Map<DateTime, int> dailyNets,
    @Default(TransactionRepository.pageSize) int limit,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,

    /// The first page was fetched, so no rows means none match.
    @Default(false) bool listLoaded,
    @Default(TransactionLookups()) TransactionLookups lookups,
    MonthlyReport? report,
    @Default({}) Map<DateTime, int> monthPickerTotals,
    String? selectedId,
    TransactionFailure? loadFailure,
    TransactionFailure? actionFailure,
  }) = _TransactionsState;
}
