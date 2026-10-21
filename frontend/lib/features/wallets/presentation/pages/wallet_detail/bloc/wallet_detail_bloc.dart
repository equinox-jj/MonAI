import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/transaction_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_daily_outflows_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/logic/wallet_form_rules.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';

part 'wallet_detail_bloc.freezed.dart';
part 'wallet_detail_event.dart';
part 'wallet_detail_state.dart';

class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {
  WalletDetailBloc({
    required String id,
    required this._watchWallet,
    required this._refreshWallet,
    required this._watchOutflows,
    required this._watchTransactions,
    required this._refreshTransactions,
    required this._watchCategories,
    required this._watchAllWallets,
    required this._archive,
    required this._setDefault,
    DateTime Function()? now,
  }) : super(_initialState(id, (now ?? DateTime.now)())) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_ArchiveRequested>(_onArchiveRequested);
    on<_SetDefaultRequested>(_onSetDefaultRequested);
    on<_WalletChanged>(_onWalletChanged);
    on<_OutflowsChanged>(_onOutflowsChanged);
    on<_TransactionsChanged>(_onTransactionsChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
    on<_AllWalletsChanged>(_onAllWalletsChanged);
  }

  final WatchWalletUseCase _watchWallet;
  final RefreshWalletUseCase _refreshWallet;
  final WatchWalletDailyOutflowsUseCase _watchOutflows;
  final WatchTransactionsUseCase _watchTransactions;
  final RefreshTransactionsUseCase _refreshTransactions;
  final WatchCategoriesUseCase _watchCategories;
  final WatchAllWalletsUseCase _watchAllWallets;
  final ArchiveWalletUseCase _archive;
  final SetDefaultWalletUseCase _setDefault;

  final List<StreamSubscription<void>> _subscriptions = [];

  static WalletDetailState _initialState(String id, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return WalletDetailState(id: id, today: today, month: monthOf(today));
  }

  TransactionListParams get _listParams => TransactionListParams(
    month: state.month,
    filter: TransactionFilter(walletId: state.id),
  );

  Future<void> _onStarted(
    _Started event,
    Emitter<WalletDetailState> emit,
  ) async {
    _subscriptions.addAll([
      _watchWallet(state.id).listen(
        (result) => result.match(
          (_) {},
          (wallet) => add(WalletDetailEvent.walletChanged(wallet)),
        ),
      ),
      _watchOutflows(
        WalletDailyOutflowsParams(month: state.month, walletId: state.id),
      ).listen(
        (result) => result.match(
          (_) {},
          (outflows) => add(WalletDetailEvent.outflowsChanged(outflows)),
        ),
      ),
      _watchTransactions(
        TransactionPageParams(
          month: state.month,
          filter: TransactionFilter(walletId: state.id),
          limit: TransactionRepository.pageSize,
        ),
      ).listen(
        (result) => result.match(
          (_) {},
          (rows) => add(WalletDetailEvent.transactionsChanged(rows)),
        ),
      ),
      _watchCategories(const NoParams()).listen(
        (result) => result.match(
          (_) {},
          (categories) => add(WalletDetailEvent.categoriesChanged(categories)),
        ),
      ),
      _watchAllWallets(const NoParams()).listen(
        (result) => result.match(
          (_) {},
          (wallets) => add(WalletDetailEvent.allWalletsChanged(wallets)),
        ),
      ),
    ]);
    await _refresh(emit);
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<WalletDetailState> emit,
  ) => _refresh(emit);

  Future<void> _refresh(Emitter<WalletDetailState> emit) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(isRefreshing: true));
    final (wallet, _) = await (
      _refreshWallet(state.id),
      _refreshTransactions(_listParams),
    ).wait;
    switch (wallet) {
      case Right():
        emit(
          _settled(
            state.copyWith(
              isRefreshing: false,
              loaded: true,
              loadFailure: null,
            ),
          ),
        );
      case Left(value: NotFoundFailure()):
        emit(state.copyWith(isRefreshing: false, isGone: true));
      case Left(value: final failure) when state.wallet != null:
        _fail(emit, failure, isRefreshing: false);
      case Left(value: final failure):
        emit(
          _settled(
            state.copyWith(
              isRefreshing: false,
              loadFailure: WalletFailure.of(failure),
            ),
          ),
        );
    }
  }

  Future<void> _onArchiveRequested(
    _ArchiveRequested event,
    Emitter<WalletDetailState> emit,
  ) async {
    final wallet = state.wallet;
    if (wallet == null || state.isBusy) return;
    emit(state.copyWith(isArchiving: true));
    final result = await _archive(wallet);
    switch (result) {
      case Right(value: final archived):
        emit(state.copyWith(isArchiving: false, archivedName: archived.name));
      case Left(value: final failure):
        _fail(emit, failure, isArchiving: false);
    }
  }

  Future<void> _onSetDefaultRequested(
    _SetDefaultRequested event,
    Emitter<WalletDetailState> emit,
  ) async {
    final wallet = state.wallet;
    if (wallet == null || wallet.isDefault || state.isBusy) return;
    emit(state.copyWith(isSettingDefault: true));
    final result = await _setDefault(wallet.id);
    switch (result) {
      case Right():
        emit(state.copyWith(isSettingDefault: false));
      case Left(value: final failure):
        _fail(emit, failure, isSettingDefault: false);
    }
  }

  void _onWalletChanged(_WalletChanged event, Emitter<WalletDetailState> emit) {
    // Dropped from the cache: deleted here or on the server.
    if (event.wallet == null && state.wallet != null) {
      emit(state.copyWith(isGone: true));
      return;
    }
    emit(_settled(state.copyWith(wallet: event.wallet)));
  }

  void _onOutflowsChanged(
    _OutflowsChanged event,
    Emitter<WalletDetailState> emit,
  ) {
    emit(state.copyWith(outflows: event.outflows));
  }

  void _onTransactionsChanged(
    _TransactionsChanged event,
    Emitter<WalletDetailState> emit,
  ) {
    emit(state.copyWith(transactions: event.transactions));
  }

  void _onCategoriesChanged(
    _CategoriesChanged event,
    Emitter<WalletDetailState> emit,
  ) {
    emit(
      state.copyWith(categories: {for (final c in event.categories) c.id: c}),
    );
  }

  void _onAllWalletsChanged(
    _AllWalletsChanged event,
    Emitter<WalletDetailState> emit,
  ) {
    emit(state.copyWith(wallets: {for (final w in event.wallets) w.id: w}));
  }

  void _fail(
    Emitter<WalletDetailState> emit,
    Failure failure, {
    bool? isRefreshing,
    bool? isArchiving,
    bool? isSettingDefault,
  }) {
    emit(
      state.copyWith(
        isRefreshing: isRefreshing ?? state.isRefreshing,
        isArchiving: isArchiving ?? state.isArchiving,
        isSettingDefault: isSettingDefault ?? state.isSettingDefault,
        actionFailure: WalletFailure.of(failure),
      ),
    );
    emit(state.copyWith(actionFailure: null));
  }

  static WalletDetailState _settled(WalletDetailState state) => state.copyWith(
    status: switch (state) {
      WalletDetailState(wallet: _?) => UiStatus.success,
      WalletDetailState(loadFailure: _?) => UiStatus.failure,
      _ => UiStatus.loading,
    },
  );

  @override
  Future<void> close() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
