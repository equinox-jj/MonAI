import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/usecase/delete_transaction_usecase.dart';
import 'package:monai/features/shared/domain/usecase/load_more_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_transactions_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_wallets_usecase.dart';
import 'package:monai/features/shared/domain/usecase/transaction_list_params.dart';
import 'package:monai/features/shared/domain/usecase/watch_cached_expense_totals_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_transactions_usecase.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/domain/usecase/watch_daily_nets_usecase.dart';
import 'package:monai/features/transactions/domain/usecase/watch_transaction_lookups_usecase.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/transactions_page.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/widgets/transactions_skeleton.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchTransactions extends Mock implements WatchTransactionsUseCase {}

class _MockRefreshTransactions extends Mock
    implements RefreshTransactionsUseCase {}

class _MockLoadMore extends Mock implements LoadMoreTransactionsUseCase {}

class _MockWatchDailyNets extends Mock implements WatchDailyNetsUseCase {}

class _MockWatchReport extends Mock implements WatchMonthlyReportUseCase {}

class _MockRefreshReport extends Mock implements RefreshMonthlyReportUseCase {}

class _MockWatchLookups extends Mock
    implements WatchTransactionLookupsUseCase {}

class _MockRefreshWallets extends Mock implements RefreshWalletsUseCase {}

class _MockRefreshCategories extends Mock implements RefreshCategoriesUseCase {}

class _MockWatchExpenseTotals extends Mock
    implements WatchCachedExpenseTotalsUseCase {}

class _MockDelete extends Mock implements DeleteTransactionUseCase {}

final _today = DateTime(2026, 10, 10);

void main() {
  late _MockWatchTransactions watchTransactions;
  late _MockRefreshTransactions refreshTransactions;
  late _MockDelete delete;
  late _MockWatchReport watchReport;
  late List<Transaction> cached;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(TransactionListParams(month: DateTime(2026)));
    registerFallbackValue(
      TransactionPageParams(month: DateTime(2026), limit: 20),
    );
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    watchTransactions = _MockWatchTransactions();
    refreshTransactions = _MockRefreshTransactions();
    delete = _MockDelete();
    watchReport = _MockWatchReport();
    cached = [
      transaction(
        id: 't1',
        note: 'Makan siang',
        amount: 35000,
        date: _today,
        createdAt: DateTime(2026, 10, 10, 12, 40),
      ),
      transaction(
        id: 't2',
        type: TransactionType.income,
        note: 'Gaji',
        amount: 8500000,
        categoryId: 'c9',
        date: DateTime(2026, 10, 1),
        createdAt: DateTime(2026, 10, 1, 9),
      ),
    ];
    when(() => watchTransactions(any()))
        .thenAnswer((_) => Stream.value(Right(cached)));
    when(() => refreshTransactions(any()))
        .thenAnswer((_) async => const Right(false));
    when(() => watchReport(any()))
        .thenAnswer((_) => Stream.value(Right(monthlyReport())));
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final watchDailyNets = _MockWatchDailyNets();
    when(() => watchDailyNets(any()))
        .thenAnswer((_) => Stream.value(Right({_today: -35000})));
    final refreshReport = _MockRefreshReport();
    when(() => refreshReport(any())).thenAnswer(
      (_) async => const Left<Failure, MonthlyReport>(Failure.notFound()),
    );
    final watchLookups = _MockWatchLookups();
    when(() => watchLookups(any())).thenAnswer(
      (_) => Stream.value(
        Right(
          TransactionLookups.of(
            categories: [category()],
            wallets: [wallet(name: 'GoPay')],
          ),
        ),
      ),
    );
    final refreshWallets = _MockRefreshWallets();
    when(() => refreshWallets(any())).thenAnswer((_) async => const Right([]));
    final refreshCategories = _MockRefreshCategories();
    when(() => refreshCategories(any()))
        .thenAnswer((_) async => const Right([]));
    final bloc = TransactionsBloc(
      watchTransactions: watchTransactions,
      refreshTransactions: refreshTransactions,
      loadMore: _MockLoadMore(),
      watchDailyNets: watchDailyNets,
      watchReport: watchReport,
      refreshReport: refreshReport,
      watchLookups: watchLookups,
      refreshWallets: refreshWallets,
      refreshCategories: refreshCategories,
      watchExpenseTotals: _MockWatchExpenseTotals(),
      delete: delete,
      now: () => DateTime(2026, 10, 10, 15),
    )..add(const TransactionsEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: Scaffold(
          body: BlocProvider.value(value: bloc, child: const TransactionsUI()),
        ),
      ),
    );
  }

  testWidgets('shows the skeleton while the first page loads', (tester) async {
    // Arrange
    when(() => watchTransactions(any()))
        .thenAnswer((_) => const Stream.empty());
    when(() => refreshTransactions(any())).thenAnswer(
      (_) =>
          Future.delayed(const Duration(seconds: 1), () => const Right(false)),
    );

    // Act
    await pumpPage(tester);
    await tester.pump();

    // Assert
    expect(find.byType(TransactionsSkeleton), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('shows the month, its totals and the rows by day', (
    tester,
  ) async {
    // Arrange
    // (two cached transactions from setUp)

    // Act
    await pumpPage(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('+Rp 5.000.000'), findsOneWidget);
    expect(find.text('−Rp 250.000'), findsOneWidget);
    expect(find.text('Today · Sat, 10 Oct'), findsOneWidget);
    expect(find.text('−Rp 35.000'), findsWidgets);
    expect(find.text('Makan siang'), findsOneWidget);
    expect(find.text('Food · GoPay · 12:40'), findsOneWidget);
    expect(find.text('Thu, 1 Oct'), findsOneWidget);
    expect(find.text('Gaji'), findsOneWidget);
  });

  testWidgets('swiping a row left deletes it', (tester) async {
    // Arrange
    when(() => delete('t1')).thenAnswer((_) async => Right(cached.first));
    await pumpPage(tester);
    await tester.pumpAndSettle();

    // Act
    await tester.drag(find.text('Makan siang'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Assert
    verify(() => delete('t1')).called(1);
    expect(find.text('Makan siang'), findsNothing);
  });

  testWidgets('an empty month offers to add a transaction', (tester) async {
    // Arrange
    cached = [];

    // Act
    await pumpPage(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('Add transaction'), findsOneWidget);
  });

  testWidgets('the type filter sheet narrows the list', (tester) async {
    // Arrange
    await pumpPage(tester);
    await tester.pumpAndSettle();

    // Act
    await tester.ensureVisible(find.text('Type', skipOffstage: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Type'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Income').last);
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    // Assert
    final fetched = verify(() => refreshTransactions(captureAny())).captured
        .cast<TransactionListParams>();
    expect(fetched.last.filter.type, TransactionType.income);
    expect(find.text('Income'), findsWidgets);
  });

  testWidgets('the previous-month button shows September', (tester) async {
    // Arrange
    await pumpPage(tester);
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('September 2026'), findsOneWidget);
  });
}
