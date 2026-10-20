import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/repository/wallet_repository.dart';
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
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/wallet_detail_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchWallet extends Mock implements WatchWalletUseCase {}

class _MockRefreshWallet extends Mock implements RefreshWalletUseCase {}

class _MockWatchOutflows extends Mock
    implements WatchWalletDailyOutflowsUseCase {}

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockWatchCategories extends Mock implements WatchCategoriesUseCase {}

class _MockWatchAllWallets extends Mock implements WatchAllWalletsUseCase {}

class _MockRepository extends Mock implements WalletRepository {}

void main() {
  final bca = wallet(
    id: 'w1',
    name: 'BCA Tabungan',
    type: WalletType.bank,
    currentBalance: 8250000,
    isDefault: true,
  );
  final gopay = wallet(id: 'w2', name: 'GoPay', type: WalletType.eWallet);

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

  Future<void> pumpDetail(WidgetTester tester, Wallet shown) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchWallet = _MockWatchWallet();
    when(() => watchWallet(shown.id))
        .thenAnswer((_) => Stream.value(Right(shown)));
    final refreshWallet = _MockRefreshWallet();
    when(() => refreshWallet(shown.id)).thenAnswer((_) async => Right(shown));
    final watchOutflows = _MockWatchOutflows();
    when(
      () => watchOutflows(any()),
    ).thenAnswer((_) => Stream.value(Right({DateTime(2026, 10, 9): 500000})));
    final watchTransactions = _MockWatchTransactions();
    when(() => watchTransactions(any())).thenAnswer(
      (_) => Stream.value(
        Right([
          transaction(
            type: TransactionType.transfer,
            note: 'Top up GoPay',
            amount: 500000,
            walletId: 'w1',
            toWalletId: 'w2',
            categoryId: null,
            date: DateTime(2026, 10, 9),
          ),
        ]),
      ),
    );
    final refreshTransactions = _MockRefreshTransactions();
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(false));
    final watchCategories = _MockWatchCategories();
    when(() => watchCategories(any()))
        .thenAnswer((_) => Stream.value(const Right([])));
    final watchAllWallets = _MockWatchAllWallets();
    when(() => watchAllWallets(any()))
        .thenAnswer((_) => Stream.value(Right([bca, gopay])));
    final bloc = WalletDetailBloc(
      id: shown.id,
      watchWallet: watchWallet,
      refreshWallet: refreshWallet,
      watchOutflows: watchOutflows,
      watchTransactions: watchTransactions,
      refreshTransactions: refreshTransactions,
      watchCategories: watchCategories,
      watchAllWallets: watchAllWallets,
      archive: ArchiveWalletUseCase(_MockRepository()),
      setDefault: SetDefaultWalletUseCase(_MockRepository()),
      now: () => DateTime(2026, 10, 10, 9),
    )..add(const WalletDetailEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const WalletDetailUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets("shows the balance, the month's money out and its rows", (
    tester,
  ) async {
    // Act
    await pumpDetail(tester, bca);

    // Assert
    expect(find.text('BCA Tabungan'), findsOneWidget);
    expect(find.text('Rp 8.250.000'), findsOneWidget);
    expect(find.text('Money out · October'), findsOneWidget);
    expect(find.text('−Rp 500.000'), findsNWidgets(2));
    expect(find.text('Top up GoPay'), findsOneWidget);
    expect(find.text('Transfer to GoPay · 9 Oct'), findsOneWidget);
  });

  testWidgets("the default wallet's Archive is off, with a note why", (
    tester,
  ) async {
    // Act
    await pumpDetail(tester, bca);

    // Assert
    expect(
      find.text(
        "Your default wallet can't be archived or deleted. Make another "
        'wallet the default first.',
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('More options'), findsNothing);
  });

  testWidgets('another wallet can be archived or made the default', (
    tester,
  ) async {
    // Act
    await pumpDetail(tester, gopay);

    // Assert
    expect(find.textContaining("can't be archived"), findsNothing);
    expect(find.text('Transfer from BCA Tabungan · 9 Oct'), findsOneWidget);
    expect(find.text('+Rp 500.000'), findsOneWidget);
    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    expect(find.text('Make default'), findsOneWidget);
  });
}
