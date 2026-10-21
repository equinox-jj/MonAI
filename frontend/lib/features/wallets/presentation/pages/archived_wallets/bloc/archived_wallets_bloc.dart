import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';

part 'archived_wallets_bloc.freezed.dart';
part 'archived_wallets_event.dart';
part 'archived_wallets_state.dart';

class ArchivedWalletsBloc
    extends Bloc<ArchivedWalletsEvent, ArchivedWalletsState> {
  ArchivedWalletsBloc({
    required this._watchAllWallets,
    required this._refreshWallets,
    required this._unarchive,
  }) : super(const ArchivedWalletsState()) {
    on<_Started>(_onStarted);
    on<_UnarchiveRequested>(_onUnarchiveRequested);
    on<_WalletsChanged>(_onWalletsChanged);
  }

  final WatchAllWalletsUseCase _watchAllWallets;
  final RefreshWalletsUseCase _refreshWallets;
  final UnarchiveWalletUseCase _unarchive;

  StreamSubscription<void>? _wallets;

  Future<void> _onStarted(
    _Started event,
    Emitter<ArchivedWalletsState> emit,
  ) async {
    _wallets = _watchAllWallets(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (wallets) => add(ArchivedWalletsEvent.walletsChanged(wallets)),
      ),
    );
    // Best effort: what is cached stays on failure.
    await _refreshWallets(const NoParams());
  }

  Future<void> _onUnarchiveRequested(
    _UnarchiveRequested event,
    Emitter<ArchivedWalletsState> emit,
  ) async {
    final id = event.id;
    if (state.restoringIds.contains(id)) return;
    emit(state.copyWith(restoringIds: {...state.restoringIds, id}));
    final result = await _unarchive(id);
    final restoring = {...state.restoringIds}..remove(id);
    switch (result) {
      case Right(value: final wallet):
        emit(state.copyWith(restoringIds: restoring, restored: wallet));
        emit(state.copyWith(restored: null));
      case Left(value: final failure):
        emit(
          state.copyWith(
            restoringIds: restoring,
            actionFailure: WalletFailure.of(failure),
          ),
        );
        emit(state.copyWith(actionFailure: null));
    }
  }

  void _onWalletsChanged(
    _WalletsChanged event,
    Emitter<ArchivedWalletsState> emit,
  ) {
    final archived = event.wallets.where((w) => w.isArchived).toList();
    emit(
      state.copyWith(
        wallets: archived,
        status: archived.isEmpty ? UiStatus.empty : UiStatus.success,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _wallets?.cancel();
    return super.close();
  }
}
