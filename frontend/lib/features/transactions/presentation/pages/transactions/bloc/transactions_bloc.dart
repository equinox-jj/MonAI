import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';
import 'package:monai/features/transactions/presentation/model/transaction_list_item.dart';

part 'transactions_bloc.freezed.dart';
part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required this._watchTransactions,
    required this._refreshTransactions,
    required this._loadMore,
    required this._watchDailyNets,
    required this._watchReport,
    required this._refreshReport,
    required this._watchLookups,
    required this._refreshWallets,
    required this._refreshCategories,
    required this._watchExpenseTotals,
    required this._delete,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(_initialState((now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_PreviousMonthPressed>(_onPreviousMonth);
    on<_NextMonthPressed>(_onNextMonth);
    on<_MonthPicked>(_onMonthPicked);
    on<_MonthPickerYearShown>(_onMonthPickerYearShown);
    on<_WalletFilterPicked>(_onWalletFilterPicked);
    on<_CategoryFilterPicked>(_onCategoryFilterPicked);
    on<_TypeFilterPicked>(_onTypeFilterPicked);
    on<_FiltersCleared>(_onFiltersCleared);
    on<_LoadMoreRequested>(_onLoadMore);
    on<_Selected>(_onSelected);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_TransactionsChanged>(_onTransactionsChanged);
    on<_DailyNetsChanged>(_onDailyNetsChanged);
    on<_ReportChanged>(_onReportChanged);
    on<_LookupsChanged>(_onLookupsChanged);
    on<_ExpenseTotalsChanged>(_onExpenseTotalsChanged);
  }

  final WatchTransactionsUseCase _watchTransactions;
  final RefreshTransactionsUseCase _refreshTransactions;
  final LoadMoreTransactionsUseCase _loadMore;
  final WatchDailyNetsUseCase _watchDailyNets;
  final WatchMonthlyReportUseCase _watchReport;
  final RefreshMonthlyReportUseCase _refreshReport;
  final WatchTransactionLookupsUseCase _watchLookups;
  final RefreshWalletsUseCase _refreshWallets;
  final RefreshCategoriesUseCase _refreshCategories;
  final WatchCachedExpenseTotalsUseCase _watchExpenseTotals;
  final DeleteTransactionUseCase _delete;
  final DateTime Function() _now;

  StreamSubscription<void>? _transactions;
  StreamSubscription<void>? _dailyNets;
  StreamSubscription<void>? _report;
  StreamSubscription<void>? _lookups;
  StreamSubscription<void>? _expenseTotals;

  static TransactionsState _initialState(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return TransactionsState(month: monthOf(today), today: today);
  }

  Future<void> _onStarted(_Started event, Emitter<TransactionsState> emit) {
    _lookups = _watchLookups(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (lookups) => add(TransactionsEvent.lookupsChanged(lookups)),
      ),
    );
    return _show(emit, state.month, state.filter);
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(today: _initialState(_now()).today));
    await _refresh(emit, refreshNames: true);
  }

  Future<void> _onPreviousMonth(
    _PreviousMonthPressed event,
    Emitter<TransactionsState> emit,
  ) => _show(
    emit,
    DateTime(state.month.year, state.month.month - 1),
    state.filter,
  );

  Future<void> _onNextMonth(
    _NextMonthPressed event,
    Emitter<TransactionsState> emit,
  ) async {
    if (!state.canShowNextMonth) return;
    await _show(
      emit,
      DateTime(state.month.year, state.month.month + 1),
      state.filter,
    );
  }

  Future<void> _onMonthPicked(
    _MonthPicked event,
    Emitter<TransactionsState> emit,
  ) async {
    final month = monthOf(event.month);
    if (month.isAfter(state.currentMonth) || month == state.month) return;
    await _show(emit, month, state.filter);
  }

  void _onMonthPickerYearShown(
    _MonthPickerYearShown event,
    Emitter<TransactionsState> emit,
  ) {
    unawaited(_expenseTotals?.cancel());
    _expenseTotals = _watchExpenseTotals(event.year).listen(
      (result) => result.match(
        (_) {},
        (totals) => add(TransactionsEvent.expenseTotalsChanged(totals)),
      ),
    );
  }

  Future<void> _onWalletFilterPicked(
    _WalletFilterPicked event,
    Emitter<TransactionsState> emit,
  ) => _showFilter(emit, state.filter.copyWith(walletId: event.walletId));

  Future<void> _onCategoryFilterPicked(
    _CategoryFilterPicked event,
    Emitter<TransactionsState> emit,
  ) => _showFilter(emit, state.filter.copyWith(categoryId: event.categoryId));

  Future<void> _onTypeFilterPicked(
    _TypeFilterPicked event,
    Emitter<TransactionsState> emit,
  ) => _showFilter(emit, state.filter.copyWith(type: event.type));

  Future<void> _onFiltersCleared(
    _FiltersCleared event,
    Emitter<TransactionsState> emit,
  ) => _showFilter(emit, const TransactionFilter());

  Future<void> _showFilter(
    Emitter<TransactionsState> emit,
    TransactionFilter filter,
  ) async {
    if (filter == state.filter) return;
    await _show(emit, state.month, filter);
  }

  Future<void> _show(
    Emitter<TransactionsState> emit,
    DateTime month,
    TransactionFilter filter,
  ) async {
    final sameMonth = month == state.month;
    emit(
      _settled(
        state.copyWith(
          month: month,
          filter: filter,
          transactions: const [],
          deletingIds: const {},
          dailyNets: const {},
          limit: TransactionRepository.pageSize,
          hasMore: false,
          isLoadingMore: false,
          listLoaded: false,
          report: sameMonth ? state.report : null,
          loadFailure: null,
        ),
      ),
    );
    _watchList();
    if (!sameMonth || _report == null) _watchMonthReport();
    await _refresh(emit, refreshNames: _report == null);
  }

  void _watchList() {
    final params = TransactionListParams(
      month: state.month,
      filter: state.filter,
    );
    unawaited(_dailyNets?.cancel());
    _dailyNets = _watchDailyNets(params).listen(
      (result) => result.match(
        (_) {},
        (nets) => add(TransactionsEvent.dailyNetsChanged(nets)),
      ),
    );
    _watchRows();
  }

  void _watchRows() {
    unawaited(_transactions?.cancel());
    _transactions =
        _watchTransactions(
          TransactionPageParams(
            month: state.month,
            filter: state.filter,
            limit: state.limit,
          ),
        ).listen(
          // A failed cache read keeps the last rows on screen.
          (result) => result.match(
            (_) {},
            (rows) => add(TransactionsEvent.transactionsChanged(rows)),
          ),
        );
  }

  void _watchMonthReport() {
    unawaited(_report?.cancel());
    _report = _watchReport(state.month).listen(
      (result) => result.match(
        (_) {},
        (report) => add(TransactionsEvent.reportChanged(report)),
      ),
    );
  }

  /// Only the list's result is reported: the totals and names are best effort.
  Future<void> _refresh(
    Emitter<TransactionsState> emit, {
    required bool refreshNames,
  }) async {
    final month = state.month;
    final filter = state.filter;
    emit(state.copyWith(isRefreshing: true));
    final (list, _, _) = await (
      _refreshTransactions(TransactionListParams(month: month, filter: filter)),
      _refreshReport(month),
      Future.wait<Object?>([
        if (refreshNames) ...[
          _refreshWallets(const NoParams()),
          _refreshCategories(const NoParams()),
        ],
      ]),
    ).wait;
    // The user moved on to another month or filter meanwhile.
    if (month != state.month || filter != state.filter) return;
    emit(_afterRefresh(list));
    _clearActionFailure(emit);
  }

  TransactionsState _afterRefresh(Either<Failure, bool> list) => switch (list) {
    Right(value: final hasMore) => _settled(
      state.copyWith(
        isRefreshing: false,
        listLoaded: true,
        hasMore: hasMore,
        loadFailure: null,
      ),
    ),
    Left(value: final failure)
        when state.listLoaded || state.transactions.isNotEmpty =>
      state.copyWith(
        isRefreshing: false,
        actionFailure: TransactionFailure.of(failure),
      ),
    Left(value: final failure) => _settled(
      state.copyWith(
        isRefreshing: false,
        loadFailure: TransactionFailure.of(failure),
      ),
    ),
  };

  Future<void> _onLoadMore(
    _LoadMoreRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore || state.isRefreshing) return;
    final month = state.month;
    final filter = state.filter;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _loadMore(
      TransactionListParams(month: month, filter: filter),
    );
    if (month != state.month || filter != state.filter) return;
    switch (result) {
      case Right(value: final hasMore):
        emit(
          state.copyWith(
            isLoadingMore: false,
            hasMore: hasMore,
            limit: state.limit + TransactionRepository.pageSize,
          ),
        );
        _watchRows();
      case Left(value: final failure):
        emit(
          state.copyWith(
            isLoadingMore: false,
            actionFailure: TransactionFailure.of(failure),
          ),
        );
    }
    _clearActionFailure(emit);
  }

  void _onSelected(_Selected event, Emitter<TransactionsState> emit) {
    emit(state.copyWith(selectedId: event.id));
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final id = event.id;
    emit(
      state.copyWith(
        deletingIds: {...state.deletingIds, id},
        selectedId: state.selectedId == id ? null : state.selectedId,
      ),
    );
    final result = await _delete(id);
    if (result case Left(value: final failure)) {
      emit(
        _settled(
          state.copyWith(
            deletingIds: {...state.deletingIds}..remove(id),
            actionFailure: TransactionFailure.of(failure),
          ),
        ),
      );
      _clearActionFailure(emit);
    }
  }

  void _onTransactionsChanged(
    _TransactionsChanged event,
    Emitter<TransactionsState> emit,
  ) {
    final rows = event.transactions;
    final ids = {for (final row in rows) row.id};
    emit(
      _settled(
        state.copyWith(
          transactions: rows,
          // Deleted from the cache: a restore may bring them back.
          deletingIds: state.deletingIds.where(ids.contains).toSet(),
        ),
      ),
    );
  }

  void _onDailyNetsChanged(
    _DailyNetsChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(dailyNets: event.nets));
  }

  void _onReportChanged(_ReportChanged event, Emitter<TransactionsState> emit) {
    emit(state.copyWith(report: event.report));
  }

  void _onLookupsChanged(
    _LookupsChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(lookups: event.lookups));
  }

  void _onExpenseTotalsChanged(
    _ExpenseTotalsChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(monthPickerTotals: event.totals));
  }

  /// The screen's listener has seen it by now.
  void _clearActionFailure(Emitter<TransactionsState> emit) {
    if (state.actionFailure != null) {
      emit(state.copyWith(actionFailure: null));
    }
  }

  static TransactionsState _settled(TransactionsState state) => state.copyWith(
    status: switch (state) {
      _ when state.visibleTransactions.isNotEmpty => UiStatus.success,
      TransactionsState(listLoaded: true) => UiStatus.empty,
      TransactionsState(loadFailure: _?) => UiStatus.failure,
      _ => UiStatus.loading,
    },
  );

  @override
  Future<void> close() async {
    await Future.wait([
      ?_transactions?.cancel(),
      ?_dailyNets?.cancel(),
      ?_report?.cancel(),
      ?_lookups?.cancel(),
      ?_expenseTotals?.cancel(),
    ]);
    return super.close();
  }
}
