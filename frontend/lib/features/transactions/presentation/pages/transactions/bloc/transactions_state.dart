part of 'transactions_bloc.dart';

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    /// The first of the month shown.
    required DateTime month,

    /// The user's current date; months after its own can't be shown.
    required DateTime today,

    /// [UiStatus.loading] while the first page loads with nothing cached
    /// (the skeleton), [UiStatus.failure] when that load failed,
    /// [UiStatus.empty] when the month has nothing that matches, otherwise
    /// [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,
    @Default(TransactionFilter()) TransactionFilter filter,

    /// The loaded rows, newest first.
    @Default([]) List<Transaction> transactions,

    /// Swiped away and being deleted; hidden until the cache drops them.
    @Default({}) Set<String> deletingIds,

    /// Each cached day's income minus expenses, for the day headers.
    @Default({}) Map<DateTime, int> dailyNets,

    /// How many rows the list shows; grows a page at a time.
    @Default(TransactionRepository.pageSize) int limit,

    /// The server has more pages.
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,

    /// The first page was fetched, so no rows means none match.
    @Default(false) bool listLoaded,
    @Default(TransactionLookups()) TransactionLookups lookups,

    /// The month's report, for the income and expense totals; null until
    /// cached.
    MonthlyReport? report,

    /// Spent per cached month of the year the month picker shows.
    @Default({}) Map<DateTime, int> monthPickerTotals,

    /// The transaction in the detail pane on a wide screen.
    String? selectedId,

    /// Why the first load failed, with nothing cached.
    TransactionFailure? loadFailure,

    /// Why a refresh or a delete failed; shown once as a snackbar.
    TransactionFailure? actionFailure,
  }) = _TransactionsState;
}

extension TransactionsStateX on TransactionsState {
  /// The first of today's month: the latest that can be shown.
  DateTime get currentMonth => monthOf(today);

  bool get canShowNextMonth => month.isBefore(currentMonth);

  /// A wallet, category or type filter is applied.
  bool get hasFilter => filter != const TransactionFilter();

  /// The rows to draw: [transactions] without the ones being deleted.
  List<Transaction> get visibleTransactions => deletingIds.isEmpty
      ? transactions
      : transactions.where((t) => !deletingIds.contains(t.id)).toList();

  /// The day-grouped rows with their headers.
  List<TransactionListItem> get items =>
      groupByDay(visibleTransactions, dailyNets: dailyNets);
}
