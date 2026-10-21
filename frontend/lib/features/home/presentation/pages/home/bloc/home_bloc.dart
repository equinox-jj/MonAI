import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/home/domain/usecase/watch_home_dashboard_usecase.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_state_extension.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this._watchDashboard,
    required this._refresh,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const HomeState()) {
    on<_Started>(_onRefresh);
    on<_Refreshed>(_onRefresh);
    on<_BalanceVisibilityToggled>(_onBalanceVisibilityToggled);
    on<_DashboardChanged>(_onDashboardChanged);
  }

  final WatchHomeDashboardUseCase _watchDashboard;
  final RefreshHomeUseCase _refresh;
  final DateTime Function() _now;

  StreamSubscription<void>? _dashboard;

  Future<void> _onRefresh(HomeEvent event, Emitter<HomeState> emit) async {
    if (state.isRefreshing) return;

    final now = _now();
    final month = monthOf(now);
    final sameMonth = state.dashboard?.month == month;

    _watch(now);

    final hasCache = state.hasCache;

    emit(
      state.copyWith(
        status: hasCache ? .success : .loading,
        isRefreshing: true,
        loadFailure: null,
        refreshFailure: null,
        budgetLoaded: sameMonth && state.budgetLoaded,
        recentLoaded: sameMonth && state.recentLoaded,
      ),
    );

    final result = (await _refresh(month)).toNullable()!;

    emit(
      state.copyWith(
        isRefreshing: false,
        budgetLoaded: state.budgetLoaded || result.budgetLoaded,
        recentLoaded: state.recentLoaded || result.recentLoaded,
      ),
    );

    final failure = result.failure;

    if (failure == null) {
      emit(state.copyWith(status: .success));
    } else if (state.hasCache) {
      // The cached dashboard stays; the screen tells the user it's stale.
      emit(state.copyWith(status: .success, refreshFailure: failure));
    } else {
      emit(state.copyWith(status: .failure, loadFailure: failure));
    }
  }

  void _watch(DateTime now) {
    unawaited(_dashboard?.cancel());
    _dashboard = _watchDashboard(now).listen(
      // A failed cache read keeps the last dashboard on screen.
      (result) => result.match(
        (_) {},
        (dashboard) => add(HomeEvent.dashboardChanged(dashboard)),
      ),
    );
  }

  void _onDashboardChanged(_DashboardChanged event, Emitter<HomeState> emit) {
    final dashboard = event.dashboard;
    // Cached data arriving ends the skeleton or the error.
    final showsDashboard = dashboard.hasCache && state.status != .success;

    emit(
      state.copyWith(
        dashboard: dashboard,
        status: showsDashboard ? .success : state.status,
        loadFailure: showsDashboard ? null : state.loadFailure,
      ),
    );
  }

  void _onBalanceVisibilityToggled(
    _BalanceVisibilityToggled event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isBalanceHidden: !state.isBalanceHidden));
  }

  @override
  Future<void> close() async {
    await _dashboard?.cancel();
    return super.close();
  }
}
