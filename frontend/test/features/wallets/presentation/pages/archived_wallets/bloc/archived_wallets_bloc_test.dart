import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/unarchive_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/bloc/archived_wallets_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockUnarchive extends Mock implements UnarchiveWalletUseCase {}

void main() {
  late _MockWatchAllWallets watchAllWallets;
  late _MockRefreshWallets refreshWallets;
  late _MockUnarchive unarchive;

  final cash = wallet(id: 'w1', isDefault: true);
  final ovo = wallet(id: 'w2', name: 'OVO', isArchived: true);

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    watchAllWallets = _MockWatchAllWallets();
    refreshWallets = _MockRefreshWallets();
    unarchive = _MockUnarchive();
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right([cash, ovo])));
    when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
  });

  Future<ArchivedWalletsBloc> started() async {
    final bloc = ArchivedWalletsBloc(
      watchAllWallets: watchAllWallets,
      refreshWallets: refreshWallets,
      unarchive: unarchive,
    )..add(const ArchivedWalletsEvent.started());
    addTearDown(bloc.close);
    await Future<void>.delayed(Duration.zero);
    return bloc;
  }

  test('lists only the archived wallets', () async {
    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.wallets, [ovo]);
  });

  test('nothing archived is empty', () async {
    // Arrange
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right([cash])));

    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.empty);
  });

  test('unarchiving reports the wallet once', () async {
    // Arrange
    final bloc = await started();
    final restored = ovo.copyWith(isArchived: false);
    when(() => unarchive('w2')).thenAnswer((_) async => Right(restored));
    final reported = <Wallet?>[];
    final sub = bloc.stream.listen((s) => reported.add(s.restored));
    addTearDown(sub.cancel);

    // Act
    bloc.add(const ArchivedWalletsEvent.unarchiveRequested('w2'));
    await Future<void>.delayed(Duration.zero);

    // Assert
    expect(reported, contains(restored));
    expect(bloc.state.restored, isNull);
    expect(bloc.state.restoringIds, isEmpty);
  });

  test('a failed unarchive reports why', () async {
    // Arrange
    final bloc = await started();
    when(() => unarchive('w2'))
        .thenAnswer((_) async => const Left(Failure.network()));
    final failures = <WalletFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
    addTearDown(sub.cancel);

    // Act
    bloc.add(const ArchivedWalletsEvent.unarchiveRequested('w2'));
    await Future<void>.delayed(Duration.zero);

    // Assert
    expect(failures, contains(WalletFailure.network));
    expect(bloc.state.restoringIds, isEmpty);
  });
}
