import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/logic/home_dashboard_rules.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/home/domain/usecase/watch_home_dashboard_usecase.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchDashboard extends Mock implements WatchHomeDashboardUseCase {}

class _MockRefreshHome extends Mock implements RefreshHomeUseCase {}

HomeDashboard _dashboard({
  bool hasCache = true,
  List<RecentTransaction> recent = const [],
  DateTime? now,
}) => buildHomeDashboard(
  now: now ?? DateTime(2026, 10, 20, 9),
  user: hasCache ? user() : null,
  wallets: const [],
  categories: const [],
  recent: const [],
  budget: null,
  report: null,
).copyWith(recent: recent);

Right<Failure, HomeRefreshResult> _refreshed({
  HomeLoadFailure? failure,
  bool loaded = true,
}) => Right(
  HomeRefreshResult(
    budgetLoaded: loaded,
    recentLoaded: loaded,
    failure: failure,
  ),
);

void main() {
  late _MockWatchDashboard watch;
  late _MockRefreshHome refresh;
  late StreamController<Either<Failure, HomeDashboard>> cache;
  late DateTime now;
  late HomeBloc bloc;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    watch = _MockWatchDashboard();
    refresh = _MockRefreshHome();
    cache = StreamController.broadcast();
    now = DateTime(2026, 10, 20, 9);
    when(() => watch(any())).thenAnswer((_) => cache.stream);
    bloc = HomeBloc(watchDashboard: watch, refresh: refresh, now: () => now);
  });

  tearDown(() async {
    await bloc.close();
    await cache.close();
  });

  test('shows the skeleton until the first load, then the dashboard', () async {
    // Arrange
    final done = Completer<Either<Failure, HomeRefreshResult>>();
    when(() => refresh(any())).thenAnswer((_) => done.future);

    // Act
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();
    final loading = bloc.state;
    cache.add(Right(_dashboard()));
    done.complete(_refreshed());
    await pumpEventQueue();

    // Assert
    expect(loading.status, UiStatus.loading);
    expect(loading.isRefreshing, isTrue);
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.isRefreshing, isFalse);
    expect(bloc.state.budgetLoaded, isTrue);
    verify(() => refresh(DateTime(2026, 10))).called(1);
  });

  test('a failed first load with nothing cached shows the error', () async {
    // Arrange
    when(() => refresh(any()))
        .thenAnswer((_) async => _refreshed(failure: .network, loaded: false));

    // Act
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();
    cache.add(Right(_dashboard(hasCache: false)));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, HomeLoadFailure.network);
    expect(bloc.state.refreshFailure, isNull);
  });

  test('a failed refresh with cached data keeps it and reports once', () async {
    // Arrange
    final done = Completer<Either<Failure, HomeRefreshResult>>();
    when(() => refresh(any())).thenAnswer((_) => done.future);
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();
    cache.add(Right(_dashboard()));
    await pumpEventQueue();

    // Act
    done.complete(_refreshed(failure: .unexpected));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.refreshFailure, HomeLoadFailure.unexpected);
    expect(bloc.state.loadFailure, isNull);
  });

  test('does not start a refresh while one is running', () async {
    // Arrange
    final done = Completer<Either<Failure, HomeRefreshResult>>();
    when(() => refresh(any())).thenAnswer((_) => done.future);
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();

    // Act
    bloc.add(const HomeEvent.refreshed());
    await pumpEventQueue();
    done.complete(_refreshed());
    await pumpEventQueue();

    // Assert
    verify(() => refresh(any())).called(1);
  });

  test('a refresh in a new month watches and fetches that month', () async {
    // Arrange
    when(() => refresh(any())).thenAnswer((_) async => _refreshed());
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();

    // Act
    now = DateTime(2026, 11, 1, 8);
    bloc.add(const HomeEvent.refreshed());
    await pumpEventQueue();

    // Assert
    verify(() => watch(DateTime(2026, 11, 1, 8))).called(1);
    verify(() => refresh(DateTime(2026, 11))).called(1);
  });

  test('a first run is a fetched month with no transactions', () async {
    // Arrange
    when(() => refresh(any())).thenAnswer((_) async => _refreshed());

    // Act
    bloc.add(const HomeEvent.started());
    await pumpEventQueue();
    cache.add(Right(_dashboard()));
    await pumpEventQueue();

    // Assert
    expect(bloc.state.isFirstRun, isTrue);
    expect(bloc.state.budgetDisplay, HomeBudgetDisplay.prompt);
  });

  test('toggles the balance mask', () async {
    // Arrange
    const event = HomeEvent.balanceVisibilityToggled();

    // Act
    bloc.add(event);
    await pumpEventQueue();

    // Assert
    expect(bloc.state.isBalanceHidden, isTrue);
  });
}
