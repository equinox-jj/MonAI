import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/refresh_transaction_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_usecase.dart';
import 'package:monai/features/transactions/presentation/model/transaction_failure.dart';

part 'transaction_detail_bloc.freezed.dart';
part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

/// One transaction: the cached copy at once, refreshed from the API. It
/// closes once the transaction is gone, deleted here or anywhere else.
class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionDetailBloc({
    required this.id,
    required this._watchTransaction,
    required this._refreshTransaction,
    required this._watchLookups,
    required this._delete,
  }) : super(const TransactionDetailState()) {
    on<_Started>(_onStarted);
    on<_Retried>(_onRetried);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_TransactionChanged>(_onTransactionChanged);
    on<_LookupsChanged>(_onLookupsChanged);
  }

  /// The transaction shown.
  final String id;

  final WatchTransactionUseCase _watchTransaction;
  final RefreshTransactionUseCase _refreshTransaction;
  final WatchTransactionLookupsUseCase _watchLookups;
  final DeleteTransactionUseCase _delete;

  StreamSubscription<void>? _transaction;
  StreamSubscription<void>? _lookups;

  Future<void> _onStarted(
    _Started event,
    Emitter<TransactionDetailState> emit,
  ) {
    _transaction = _watchTransaction(id).listen(
      (result) => result.match(
        (_) {},
        (transaction) =>
            add(TransactionDetailEvent.transactionChanged(transaction)),
      ),
    );
    _lookups = _watchLookups(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (lookups) => add(TransactionDetailEvent.lookupsChanged(lookups)),
      ),
    );
    return _refresh(emit);
  }

  Future<void> _onRetried(
    _Retried event,
    Emitter<TransactionDetailState> emit,
  ) async {
    if (state.isRefreshing) return;
    await _refresh(emit);
  }

  Future<void> _refresh(Emitter<TransactionDetailState> emit) async {
    emit(_settled(state.copyWith(isRefreshing: true, loadFailure: null)));
    final result = await _refreshTransaction(id);
    emit(
      _settled(
        state.copyWith(
          isRefreshing: false,
          // A stale copy beats an error; a gone one fails as not found.
          loadFailure: switch (result) {
            Left(value: final failure) => TransactionFailure.of(failure),
            Right() => null,
          },
        ),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<TransactionDetailState> emit,
  ) async {
    if (state.isDeleting || state.transaction == null) return;
    emit(state.copyWith(isDeleting: true));
    final result = await _delete(id);
    switch (result) {
      case Right():
        emit(state.copyWith(isDeleting: false, isClosed: true));
      case Left(value: final failure):
        emit(
          state.copyWith(
            isDeleting: false,
            actionFailure: TransactionFailure.of(failure),
          ),
        );
        emit(state.copyWith(actionFailure: null));
    }
  }

  void _onTransactionChanged(
    _TransactionChanged event,
    Emitter<TransactionDetailState> emit,
  ) {
    final transaction = event.transaction;
    // It was on screen and left the cache: deleted, here or elsewhere.
    if (transaction == null && state.transaction != null) {
      emit(state.copyWith(isClosed: true));
      return;
    }
    emit(_settled(state.copyWith(transaction: transaction)));
  }

  void _onLookupsChanged(
    _LookupsChanged event,
    Emitter<TransactionDetailState> emit,
  ) {
    emit(state.copyWith(lookups: event.lookups));
  }

  static TransactionDetailState _settled(TransactionDetailState state) =>
      state.copyWith(
        status: switch (state) {
          TransactionDetailState(transaction: _?) => UiStatus.success,
          TransactionDetailState(isRefreshing: false, loadFailure: _?) =>
            UiStatus.failure,
          _ => UiStatus.loading,
        },
      );

  @override
  Future<void> close() async {
    await Future.wait([?_transaction?.cancel(), ?_lookups?.cancel()]);
    return super.close();
  }
}
