import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

void main() {
  late _MockWatchWallets watchWallets;
  late _MockWatchAllWallets watchAllWallets;
  late _MockRefreshWallets refreshWallets;
  late StreamController<Either<Failure, List<Wallet>>> cache;

  final bca = wallet(id: 'w1', name: 'BCA', isDefault: true);
  final cash = wallet(id: 'w2');
  final ovo = wallet(id: 'w3', name: 'OVO', isArchived: true);

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    watchWallets = _MockWatchWallets();
    watchAllWallets = _MockWatchAllWallets();
    refreshWallets = _MockRefreshWallets();
    cache = StreamController.broadcast();
    addTearDown(cache.close);
    when(() => watchWallets(any())).thenAnswer((_) => cache.stream);
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right([bca, cash, ovo])));
    when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
  });

  Future<WalletsBloc> started() async {
    final bloc = WalletsBloc(
      watchWallets: watchWallets,
      watchAllWallets: watchAllWallets,
      refreshWallets: refreshWallets,
    )..add(const WalletsEvent.started());
    addTearDown(bloc.close);
    await Future<void>.delayed(Duration.zero);
    return bloc;
  }

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('shows the cached wallets and counts the archived ones', () async {
    // Arrange
    final bloc = await started();

    // Act
    cache.add(Right([bca, cash]));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.wallets, [bca, cash]);
    expect(bloc.state.archivedCount, 1);
    verify(() => refreshWallets(const NoParams())).called(1);
  });

  test('no wallets after the server answered is empty', () async {
    // Arrange
    final bloc = await started();

    // Act
    cache.add(const Right([]));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.empty);
  });

  test('a failed first load with nothing cached is an error', () async {
    // Arrange
    when(() => refreshWallets(any()))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, WalletFailure.network);
  });

  test('a failed refresh keeps the cache and reports once', () async {
    // Arrange
    final bloc = await started();
    cache.add(Right([bca]));
    await settle();
    when(() => refreshWallets(any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final failures = <WalletFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
    addTearDown(sub.cancel);

    // Act
    bloc.add(const WalletsEvent.refreshed());
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(failures, contains(WalletFailure.network));
    expect(bloc.state.actionFailure, isNull);
  });

  test('shownId follows the pick while it is listed, else the first', () async {
    // Arrange
    final bloc = await started();
    cache.add(Right([bca, cash]));
    await settle();

    // Act
    bloc.add(const WalletsEvent.selected('w2'));
    await settle();
    final picked = bloc.state.shownId;
    cache.add(Right([bca]));
    await settle();

    // Assert
    expect(picked, 'w2');
    expect(bloc.state.shownId, 'w1');
  });
}
