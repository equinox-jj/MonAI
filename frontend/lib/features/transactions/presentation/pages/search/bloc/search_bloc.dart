import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/recent_searches_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/search_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_cached_search_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/domain/validation/search_query.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:rxdart/rxdart.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

/// Search over notes and merchants: one month on the server, page by page,
/// or every cached month on the device. Typing searches once it pauses; a
/// newer search replaces an older one still running.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  /// [initialMonth] is any day of the month to search first; [now] is the
  /// clock and [debounce] the typing pause; tests pass their own.
  SearchBloc({
    required this._search,
    required this._watchCachedSearch,
    required this._watchLookups,
    required this._watchExpenseTotals,
    required this._getRecentSearches,
    required this._addRecentSearch,
    DateTime? initialMonth,
    DateTime Function()? now,
    Duration debounce = const Duration(milliseconds: 300),
  }) : super(_initialState(initialMonth, (now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_QueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) =>
          events.debounceTime(debounce).switchMap(mapper),
    );
    on<_Submitted>(_onSubmitted);
    on<_RecentUsed>(_onRecentUsed);
    on<_AllMonthsToggled>(_onAllMonthsToggled);
    on<_MonthPicked>(_onMonthPicked);
    on<_MonthPickerYearShown>(_onMonthPickerYearShown);
    on<_WalletFilterPicked>(_onWalletFilterPicked);
    on<_CategoryFilterPicked>(_onCategoryFilterPicked);
    on<_TypeFilterPicked>(_onTypeFilterPicked);
    on<_FiltersCleared>(_onFiltersCleared);
    on<_LoadMoreRequested>(_onLoadMore);
    on<_Retried>(_onRetried);
    on<_CachedResultsChanged>(_onCachedResultsChanged);
    on<_LookupsChanged>(_onLookupsChanged);
    on<_ExpenseTotalsChanged>(_onExpenseTotalsChanged);
  }

  final SearchTransactionsUseCase _search;
  final WatchCachedSearchUseCase _watchCachedSearch;
  final WatchTransactionLookupsUseCase _watchLookups;
  final WatchCachedExpenseTotalsUseCase _watchExpenseTotals;
  final GetRecentSearchesUseCase _getRecentSearches;
  final AddRecentSearchUseCase _addRecentSearch;

  StreamSubscription<void>? _cached;
  StreamSubscription<void>? _lookups;
  StreamSubscription<void>? _expenseTotals;

  /// Counts searches, so a slow one can't overwrite a newer one.
  int _searchId = 0;

  static SearchState _initialState(DateTime? initialMonth, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final current = monthOf(today);
    final month = switch (initialMonth) {
      final m? when !monthOf(m).isAfter(current) => monthOf(m),
      _ => current,
    };
    return SearchState(month: month, today: today);
  }

  Future<void> _onStarted(_Started event, Emitter<SearchState> emit) async {
    _lookups = _watchLookups(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (lookups) => add(SearchEvent.lookupsChanged(lookups)),
      ),
    );
    final recent = await _getRecentSearches(const NoParams());
    emit(state.copyWith(recentSearches: recent.getOrElse((_) => const [])));
  }

  Future<void> _onQueryChanged(
    _QueryChanged event,
    Emitter<SearchState> emit,
  ) => _run(emit, state.copyWith(query: event.query));

  Future<void> _onSubmitted(_Submitted event, Emitter<SearchState> emit) async {
    if (!state.hasQuery) return;
    final recent = await _addRecentSearch(state.query);
    if (recent case Right(value: final searches)) {
      emit(state.copyWith(recentSearches: searches));
    }
  }

  Future<void> _onRecentUsed(
    _RecentUsed event,
    Emitter<SearchState> emit,
  ) async {
    await _run(emit, state.copyWith(query: event.query));
    add(const SearchEvent.submitted());
  }

  Future<void> _onAllMonthsToggled(
    _AllMonthsToggled event,
    Emitter<SearchState> emit,
  ) => _run(emit, state.copyWith(allMonths: event.allMonths));

  Future<void> _onMonthPicked(
    _MonthPicked event,
    Emitter<SearchState> emit,
  ) async {
    final month = monthOf(event.month);
    if (month.isAfter(state.currentMonth)) return;
    await _run(emit, state.copyWith(month: month, allMonths: false));
  }

  void _onMonthPickerYearShown(
    _MonthPickerYearShown event,
    Emitter<SearchState> emit,
  ) {
    unawaited(_expenseTotals?.cancel());
    _expenseTotals = _watchExpenseTotals(event.year).listen(
      (result) => result.match(
        (_) {},
        (totals) => add(SearchEvent.expenseTotalsChanged(totals)),
      ),
    );
  }

  Future<void> _onWalletFilterPicked(
    _WalletFilterPicked event,
    Emitter<SearchState> emit,
  ) => _run(
    emit,
    state.copyWith(filter: state.filter.copyWith(walletId: event.walletId)),
  );

  Future<void> _onCategoryFilterPicked(
    _CategoryFilterPicked event,
    Emitter<SearchState> emit,
  ) => _run(
    emit,
    state.copyWith(filter: state.filter.copyWith(categoryId: event.categoryId)),
  );

  Future<void> _onTypeFilterPicked(
    _TypeFilterPicked event,
    Emitter<SearchState> emit,
  ) => _run(
    emit,
    state.copyWith(filter: state.filter.copyWith(type: event.type)),
  );

  Future<void> _onFiltersCleared(
    _FiltersCleared event,
    Emitter<SearchState> emit,
  ) => _run(emit, state.copyWith(filter: const TransactionFilter()));

  Future<void> _onRetried(_Retried event, Emitter<SearchState> emit) =>
      _run(emit, state);

  /// Shows [next] and searches it from the first page.
  Future<void> _run(Emitter<SearchState> emit, SearchState next) async {
    final id = ++_searchId;
    unawaited(_cached?.cancel());
    _cached = null;
    if (!next.hasQuery) {
      emit(
        next.copyWith(
          status: UiStatus.initial,
          results: const [],
          nextCursor: null,
          failure: null,
        ),
      );
      return;
    }
    emit(
      next.copyWith(
        status: UiStatus.loading,
        results: const [],
        nextCursor: null,
        limit: TransactionRepository.pageSize,
        isLoadingMore: false,
        failure: null,
      ),
    );
    if (state.allMonths) {
      _watchCached();
      return;
    }
    final result = await _search(
      SearchTransactionsParams(
        query: state.query,
        month: state.month,
        filter: state.filter,
      ),
    );
    if (id != _searchId) return;
    switch (result) {
      case Right(value: final page):
        emit(
          state.copyWith(
            status: page.items.isEmpty ? UiStatus.empty : UiStatus.success,
            results: page.items,
            nextCursor: page.nextCursor,
          ),
        );
      case Left(value: final failure):
        emit(
          state.copyWith(
            status: UiStatus.failure,
            failure: TransactionFailure.of(failure),
          ),
        );
    }
  }

  void _watchCached() {
    unawaited(_cached?.cancel());
    _cached =
        _watchCachedSearch(
          CachedSearchParams(
            query: state.query,
            filter: state.filter,
            limit: state.limit,
          ),
        ).listen(
          (result) => result.match(
            (_) {},
            (results) => add(SearchEvent.cachedResultsChanged(results)),
          ),
        );
  }

  void _onCachedResultsChanged(
    _CachedResultsChanged event,
    Emitter<SearchState> emit,
  ) {
    if (!state.allMonths || !state.hasQuery) return;
    final results = event.results;
    emit(
      state.copyWith(
        status: results.isEmpty ? UiStatus.empty : UiStatus.success,
        results: results,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> _onLoadMore(
    _LoadMoreRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore || state.status != .success) {
      return;
    }
    if (state.allMonths) {
      emit(
        state.copyWith(
          isLoadingMore: true,
          limit: state.limit + TransactionRepository.pageSize,
        ),
      );
      _watchCached();
      return;
    }
    final id = _searchId;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _search(
      SearchTransactionsParams(
        query: state.query,
        month: state.month,
        filter: state.filter,
        cursor: state.nextCursor,
      ),
    );
    if (id != _searchId) return;
    emit(switch (result) {
      Right(value: final page) => state.copyWith(
        isLoadingMore: false,
        results: [...state.results, ...page.items],
        nextCursor: page.nextCursor,
      ),
      // The loaded results stay; scrolling again retries.
      Left() => state.copyWith(isLoadingMore: false),
    });
  }

  void _onLookupsChanged(_LookupsChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(lookups: event.lookups));
  }

  void _onExpenseTotalsChanged(
    _ExpenseTotalsChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(monthPickerTotals: event.totals));
  }

  @override
  Future<void> close() async {
    await Future.wait([
      ?_cached?.cancel(),
      ?_lookups?.cancel(),
      ?_expenseTotals?.cancel(),
    ]);
    return super.close();
  }
}
