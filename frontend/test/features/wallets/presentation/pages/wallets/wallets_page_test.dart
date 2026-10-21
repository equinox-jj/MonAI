import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_all_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_daily_outflows_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallet_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_wallets_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/archive_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/refresh_wallet_usecase.dart';
import 'package:monai/features/wallets/domain/usecase/set_default_wallet_usecase.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/wallet_detail_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/wallets_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchWallets extends Mock implements WatchWalletsUseCase {}

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockWatchWallet extends Mock implements WatchWalletUseCase {}

class _MockRefreshWallet extends Mock implements RefreshWalletUseCase {}

class _MockWatchOutflows extends Mock
    implements WatchWalletDailyOutflowsUseCase {}

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

class _MockRepository extends Mock implements WalletRepository {}

void main() {
  late List<Wallet> active;
  late List<Wallet> all;

  final bca = wallet(
    id: 'w1',
    name: 'BCA Tabungan',
    type: WalletType.bank,
    currentBalance: 8250000,
    isDefault: true,
  );
  final gopay = wallet(
    id: 'w2',
    name: 'GoPay',
    type: WalletType.eWallet,
    currentBalance: 1185000,
  );
  final ovo = wallet(id: 'w3', name: 'OVO', isArchived: true);

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(TransactionListParams(month: DateTime(2026)));
    registerFallbackValue(
      TransactionPageParams(month: DateTime(2026), limit: 20),
    );
    registerFallbackValue(
      WalletDailyOutflowsParams(month: DateTime(2026), walletId: ''),
    );
  });

  setUp(() {
    active = [bca, gopay];
    all = [bca, gopay, ovo];
  });

  tearDown(sl.reset);

  void registerDetail() {
    final watchWallet = _MockWatchWallet();
    when(() => watchWallet(any())).thenAnswer(
      (invocation) => Stream.value(
        Right(
          active.firstWhere((w) => w.id == invocation.positionalArguments[0]),
        ),
      ),
    );
    final refreshWallet = _MockRefreshWallet();
    when(() => refreshWallet(any())).thenAnswer((_) async => Right(bca));
    final watchOutflows = _MockWatchOutflows();
    when(() => watchOutflows(any()))
        .thenAnswer((_) => Stream.value(const Right({})));
    final watchTransactions = _MockWatchTransactions();
    when(() => watchTransactions(any()))
        .thenAnswer((_) => Stream.value(const Right([])));
    final refreshTransactions = _MockRefreshTransactions();
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(false));
    final watchCategories = _MockWatchCategories();
    when(() => watchCategories(any()))
        .thenAnswer((_) => Stream.value(const Right([])));
    final watchAllWallets = _MockWatchAllWallets();
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right(all)));
    sl.registerFactoryParam<WalletDetailBloc, String, void>(
      (id, _) => WalletDetailBloc(
        id: id,
        watchWallet: watchWallet,
        refreshWallet: refreshWallet,
        watchOutflows: watchOutflows,
        watchTransactions: watchTransactions,
        refreshTransactions: refreshTransactions,
        watchCategories: watchCategories,
        watchAllWallets: watchAllWallets,
        archive: ArchiveWalletUseCase(_MockRepository()),
        setDefault: SetDefaultWalletUseCase(_MockRepository()),
        now: () => DateTime(2026, 10, 10),
      ),
    );
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    Size size = const Size(390, 1200),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchWallets = _MockWatchWallets();
    when(() => watchWallets(any()))
        .thenAnswer((_) => Stream.value(Right(active)));
    final watchAllWallets = _MockWatchAllWallets();
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right(all)));
    final refreshWallets = _MockRefreshWallets();
    when(() => refreshWallets(any())).thenAnswer((_) async => Right(all));
    final bloc = WalletsBloc(
      watchWallets: watchWallets,
      watchAllWallets: watchAllWallets,
      refreshWallets: refreshWallets,
    )..add(const WalletsEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: Scaffold(
          body: BlocProvider.value(value: bloc, child: const WalletsUI()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the total, its split and a card per wallet', (
    tester,
  ) async {
    // Act
    await pumpPage(tester);

    // Assert
    expect(find.text('Total across 2 wallets'), findsOneWidget);
    expect(find.text('Rp 9.435.000'), findsOneWidget);
    expect(find.text('Bank 87%'), findsOneWidget);
    expect(find.text('E-wallet 13%'), findsOneWidget);
    expect(find.text('BCA Tabungan'), findsOneWidget);
    expect(find.text('Rp 1.185.000'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Show 1 archived wallet'), findsOneWidget);
  });

  testWidgets('hides the archived button while nothing is archived', (
    tester,
  ) async {
    // Arrange
    all = [bca, gopay];

    // Act
    await pumpPage(tester);

    // Assert
    expect(find.textContaining('archived'), findsNothing);
  });

  testWidgets('tablet landscape shows the tapped wallet beside the list', (
    tester,
  ) async {
    // Arrange
    registerDetail();
    await pumpPage(tester, size: const Size(1280, 800));
    expect(find.byType(WalletDetailPage), findsOneWidget);

    // Act
    await tester.tap(find.text('GoPay'));
    await tester.pumpAndSettle();

    // Assert
    final pane = tester.widget<WalletDetailPage>(find.byType(WalletDetailPage));
    expect(pane.id, 'w2');
    expect(find.text('Current balance'), findsOneWidget);
  });
}
