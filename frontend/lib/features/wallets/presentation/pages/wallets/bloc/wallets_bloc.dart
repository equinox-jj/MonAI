import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/logic/wallet_totals.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';

part 'wallets_bloc.freezed.dart';
part 'wallets_event.dart';
part 'wallets_state.dart';

class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  WalletsBloc({
    required this._watchWallets,
    required this._watchAllWallets,
    required this._refreshWallets,
  }) : super(const WalletsState()) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_Selected>(_onSelected);
    on<_WalletsChanged>(_onWalletsChanged);
    on<_AllWalletsChanged>(_onAllWalletsChanged);
  }

  final WatchWalletsUseCase _watchWallets;
  final WatchAllWalletsUseCase _watchAllWallets;
  final RefreshWalletsUseCase _refreshWallets;

  StreamSubscription<void>? _wallets;
  StreamSubscription<void>? _allWallets;

  Future<void> _onStarted(_Started event, Emitter<WalletsState> emit) {
    _wallets = _watchWallets(const NoParams()).listen(
      // A failed cache read keeps the last wallets on screen.
      (result) => result.match(
        (_) {},
        (wallets) => add(WalletsEvent.walletsChanged(wallets)),
      ),
    );
    _allWallets = _watchAllWallets(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (wallets) => add(WalletsEvent.allWalletsChanged(wallets)),
      ),
    );
    return _refresh(emit);
  }

  Future<void> _onRefreshed(_Refreshed event, Emitter<WalletsState> emit) =>
      _refresh(emit);

  Future<void> _refresh(Emitter<WalletsState> emit) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(isRefreshing: true));
    final result = await _refreshWallets(const NoParams());
    switch (result) {
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
      case Left(value: final failure) when state.wallets.isNotEmpty:
        emit(
          state.copyWith(
            isRefreshing: false,
            actionFailure: WalletFailure.of(failure),
          ),
        );
        emit(state.copyWith(actionFailure: null));
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

  void _onSelected(_Selected event, Emitter<WalletsState> emit) {
    emit(state.copyWith(selectedId: event.id));
  }

  void _onWalletsChanged(_WalletsChanged event, Emitter<WalletsState> emit) {
    emit(_settled(state.copyWith(wallets: event.wallets)));
  }

  void _onAllWalletsChanged(
    _AllWalletsChanged event,
    Emitter<WalletsState> emit,
  ) {
    emit(
      state.copyWith(
        archivedCount: event.wallets.where((w) => w.isArchived).length,
      ),
    );
  }

  static WalletsState _settled(WalletsState state) => state.copyWith(
    status: switch (state) {
      _ when state.wallets.isNotEmpty => UiStatus.success,
      WalletsState(loaded: true) => UiStatus.empty,
      WalletsState(loadFailure: _?) => UiStatus.failure,
      _ => UiStatus.loading,
    },
  );

  @override
  Future<void> close() async {
    await Future.wait([?_wallets?.cancel(), ?_allWallets?.cancel()]);
    return super.close();
  }
}
