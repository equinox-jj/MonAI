import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_daily_outflows_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockWatchWallet extends Mock implements WatchWalletUseCase {}

class _MockRefreshWallet extends Mock implements RefreshWalletUseCase {}

class _MockWatchOutflows extends Mock
    implements WatchWalletDailyOutflowsUseCase {}

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockArchive extends Mock implements ArchiveWalletUseCase {}

class _MockSetDefault extends Mock implements SetDefaultWalletUseCase {}

void main() {
  late _MockWatchWallet watchWallet;
  late _MockRefreshWallet refreshWallet;
  late _MockWatchOutflows watchOutflows;
  late _MockWatchTransactions watchTransactions;
  late _MockRefreshTransactions refreshTransactions;
  late _MockWatchCategories watchCategories;
  late _MockWatchAllWallets watchAllWallets;
  late _MockArchive archive;
  late _MockSetDefault setDefault;
  late StreamController<Either<Failure, Wallet?>> cached;

  final gopay = wallet(id: 'w2', name: 'GoPay');

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(gopay);
    registerFallbackValue(TransactionListParams(month: DateTime(2026)));
    registerFallbackValue(
      TransactionPageParams(month: DateTime(2026), limit: 20),
    );
    registerFallbackValue(
      WalletDailyOutflowsParams(month: DateTime(2026), walletId: ''),
    );
  });

  setUp(() {
    watchWallet = _MockWatchWallet();
    refreshWallet = _MockRefreshWallet();
    watchOutflows = _MockWatchOutflows();
    watchTransactions = _MockWatchTransactions();
    refreshTransactions = _MockRefreshTransactions();
    watchCategories = _MockWatchCategories();
    watchAllWallets = _MockWatchAllWallets();
    archive = _MockArchive();
    setDefault = _MockSetDefault();
    cached = StreamController.broadcast();
    addTearDown(cached.close);
    when(() => watchWallet('w2')).thenAnswer((_) => cached.stream);
    when(() => refreshWallet('w2')).thenAnswer((_) async => Right(gopay));
    when(() => watchOutflows(any())).thenAnswer(
      (_) => Stream.value(
        Right({DateTime(2026, 10, 2): 28000, DateTime(2026, 10, 10): 35000}),
      ),
    );
    when(() => watchTransactions(any()))
        .thenAnswer((_) => Stream.value(Right([transaction(walletId: 'w2')])));
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(false));
    when(() => watchCategories(any()))
        .thenAnswer((_) => Stream.value(const Right([])));
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right([gopay])));
  });

  Future<WalletDetailBloc> started() async {
    final bloc = WalletDetailBloc(
      id: 'w2',
      watchWallet: watchWallet,
      refreshWallet: refreshWallet,
      watchOutflows: watchOutflows,
      watchTransactions: watchTransactions,
      refreshTransactions: refreshTransactions,
      watchCategories: watchCategories,
      watchAllWallets: watchAllWallets,
      archive: archive,
      setDefault: setDefault,
      now: () => DateTime(2026, 10, 10, 9),
    )..add(const WalletDetailEvent.started());
    addTearDown(bloc.close);
    await Future<void>.delayed(Duration.zero);
    return bloc;
  }

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test("shows the wallet, this month's money out and transactions", () async {
    // Arrange
    final bloc = await started();

    // Act
    cached.add(Right(gopay));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.month, DateTime(2026, 10));
    expect(bloc.state.dailyOutflows, [0, 28000, 0, 0, 0, 0, 0, 0, 0, 35000]);
    expect(bloc.state.monthOutflow, 63000);
    expect(bloc.state.transactions, hasLength(1));
    final params =
        verify(() => watchTransactions(captureAny())).captured.single
            as TransactionPageParams;
    expect(params.filter.walletId, 'w2');
  });

  test('a wallet the server no longer has closes the screen', () async {
    // Arrange
    when(() => refreshWallet('w2'))
        .thenAnswer((_) async => const Left(Failure.notFound()));

    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.isGone, isTrue);
  });

  test('a wallet dropped from the cache closes the screen', () async {
    // Arrange
    final bloc = await started();
    cached.add(Right(gopay));
    await settle();

    // Act
    cached.add(const Right(null));
    await settle();

    // Assert
    expect(bloc.state.isGone, isTrue);
  });

  test('archiving reports the name', () async {
    // Arrange
    final bloc = await started();
    cached.add(Right(gopay));
    await settle();
    when(() => archive(gopay))
        .thenAnswer((_) async => Right(gopay.copyWith(isArchived: true)));

    // Act
    bloc.add(const WalletDetailEvent.archiveRequested());
    await settle();

    // Assert
    expect(bloc.state.archivedName, 'GoPay');
    expect(bloc.state.isArchiving, isFalse);
  });

  test("the default wallet can't be archived", () async {
    // Arrange
    final bloc = await started();

    // Act
    cached.add(Right(gopay.copyWith(isDefault: true)));
    await settle();

    // Assert
    expect(bloc.state.canArchive, isFalse);
  });

  test('making it the default reports a failure once', () async {
    // Arrange
    final bloc = await started();
    cached.add(Right(gopay));
    await settle();
    when(() => setDefault('w2')).thenAnswer(
      (_) async => const Left(Failure.validation([], code: 'wallet_archived')),
    );
    final failures = <WalletFailure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
    addTearDown(sub.cancel);

    // Act
    bloc.add(const WalletDetailEvent.setDefaultRequested());
    await settle();

    // Assert
    expect(failures, contains(WalletFailure.archived));
    expect(bloc.state.isSettingDefault, isFalse);
  });
}
