import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/home/domain/logic/home_dashboard_rules.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/home/domain/usecase/watch_home_dashboard_usecase.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_load_error.dart';
import 'package:monai/features/home/presentation/pages/home/widgets/home_skeleton.dart';
import 'package:monai/features/settings/presentation/pages/settings/settings_page.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/transactions_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/wallets_page.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockWatchDashboard extends Mock implements WatchHomeDashboardUseCase {}

class _MockRefreshHome extends Mock implements RefreshHomeUseCase {}

final _now = DateTime(2026, 10, 20, 19);

HomeDashboard _dashboard({
  List<Wallet>? wallets,
  List<Transaction>? recent,
  bool withBudget = true,
}) => buildHomeDashboard(
  now: _now,
  user: user(name: 'Joshua Putra'),
  wallets:
      wallets ??
      [
        wallet(id: 'w1', name: 'BCA Tabungan', currentBalance: 8250000),
        wallet(
          id: 'w2',
          name: 'GoPay',
          currentBalance: 1185000,
          isDefault: true,
        ),
      ],
  categories: <Category>[category()],
  recent:
      recent ??
      [
        transaction(
          note: 'Makan siang',
          amount: 35000,
          date: DateTime(2026, 10, 19),
        ),
        transaction(
          id: 't2',
          type: TransactionType.transfer,
          categoryId: null,
          toWalletId: 'w2',
          amount: 500000,
          date: DateTime(2026, 10, 3),
        ),
      ],
  budget: withBudget ? budget() : null,
  report: monthlyReport(
    expenseChangePercent: -10,
    categories: [categoryBreakdown()],
  ),
);

HomeRefreshResult _result({HomeLoadFailure? failure, bool loaded = true}) =>
    HomeRefreshResult(
      budgetLoaded: loaded,
      recentLoaded: loaded,
      failure: failure,
    );

void main() {
  late _MockWatchDashboard watch;
  late _MockRefreshHome refresh;

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    watch = _MockWatchDashboard();
    refresh = _MockRefreshHome();
    when(() => refresh(any())).thenAnswer((_) async => Right(_result()));
    sl.registerFactory(
      () => HomeBloc(watchDashboard: watch, refresh: refresh, now: () => _now),
    );
  });

  tearDown(sl.reset);

  void cacheHolds(HomeDashboard dashboard) => when(
    () => watch(any()),
  ).thenAnswer((_) => Stream.value(Right<Failure, HomeDashboard>(dashboard)));

  Future<void> pumpHome(
    WidgetTester tester, {
    Size size = const Size(390, 1600),
    bool settle = true,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final sessionManager = SessionManager()..signedIn();
    addTearDown(sessionManager.dispose);
    final router = createAppRouter(
      sessionManager: sessionManager,
      isOnboardingCompleted: () async => true,
      initialLocation: AppRoutes.home,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        routerConfig: router,
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump();
    }
  }

  testWidgets('shows the skeleton while the first load runs', (tester) async {
    // Arrange
    when(() => watch(any())).thenAnswer((_) => const Stream.empty());
    when(() => refresh(any())).thenAnswer(
      (_) => Future.delayed(const Duration(seconds: 1), () => Right(_result())),
    );

    // Act
    await pumpHome(tester, settle: false);

    // Assert
    expect(find.byType(HomeSkeleton), findsOneWidget);
    expect(find.bySemanticsLabel('Loading your dashboard'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a failed first load shows the error, and retry refreshes', (
    tester,
  ) async {
    // Arrange
    when(() => watch(any())).thenAnswer((_) => const Stream.empty());
    when(
      () => refresh(any()),
    ).thenAnswer((_) async => Right(_result(failure: .network, loaded: false)));
    await pumpHome(tester);

    // Act
    expect(find.byType(HomeLoadError), findsOneWidget);
    expect(find.textContaining('Connect to the internet'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    // Assert
    verify(() => refresh(any())).called(2);
  });

  testWidgets('shows every section of the dashboard', (tester) async {
    // Arrange
    cacheHolds(_dashboard());

    // Act
    await pumpHome(tester);

    // Assert
    expect(find.text('Good evening,'), findsOneWidget);
    expect(find.text('Joshua Putra'), findsOneWidget);
    expect(find.text('Total balance · 2 wallets'), findsOneWidget);
    expect(find.text('Rp 9.435.000'), findsOneWidget);
    expect(find.text('10% less spent than September'), findsOneWidget);
    expect(find.text('makan siang 35rb pakai gopay'), findsOneWidget);
    expect(find.text('Wallets'), findsWidgets);
    expect(find.text('October budget'), findsOneWidget);
    expect(find.text('Where it went'), findsOneWidget);
    expect(find.text('Makan siang'), findsOneWidget);
    expect(find.text('Food · BCA Tabungan · Yesterday'), findsOneWidget);
    expect(
      find.text('Transfer · BCA Tabungan → GoPay · 3 Oct'),
      findsOneWidget,
    );
    expect(find.text('−Rp 35.000'), findsOneWidget);
    expect(find.text('Rp 500.000'), findsOneWidget);
  });

  testWidgets('a month with nothing recorded shows the first-run layout', (
    tester,
  ) async {
    // Arrange
    cacheHolds(_dashboard(wallets: [wallet()], recent: [], withBudget: false));

    // Act
    await pumpHome(tester);

    // Assert
    expect(find.text('Welcome,'), findsOneWidget);
    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('No budget for October'), findsOneWidget);
    expect(find.text('Add BCA, GoPay and more'), findsOneWidget);
    expect(find.text('makan siang 35rb pakai gopay'), findsNothing);
    expect(find.byTooltip('Search transactions'), findsNothing);
    expect(find.byType(MonAIWalletCard), findsNothing);
  });

  testWidgets('the eye masks every amount', (tester) async {
    // Arrange
    cacheHolds(_dashboard());
    await pumpHome(tester);

    // Act
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Rp 9.435.000'), findsNothing);
    expect(find.text('Rp ••••••'), findsNWidgets(3));
    expect(find.byTooltip('Balance hidden, show balance'), findsOneWidget);
  });

  testWidgets('a failed refresh with cached data shows the snackbar', (
    tester,
  ) async {
    // Arrange
    cacheHolds(_dashboard());
    // The cache answers before the network does.
    when(() => refresh(any())).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 10),
        () => Right(_result(failure: .network)),
      ),
    );

    // Act
    await pumpHome(tester, settle: false);
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    // Assert
    expect(find.text("You're offline. Showing saved data."), findsOneWidget);
    expect(find.text('Joshua Putra'), findsOneWidget);
  });

  for (final (name, tap, page) in [
    ('Wallets "See all"', () => find.text('See all').first, WalletsPage),
    ('Recent "See all"', () => find.text('See all').last, TransactionsPage),
    ('the avatar', () => find.byType(MonAIAvatar), SettingsPage),
  ]) {
    testWidgets('$name switches to its tab', (tester) async {
      // Arrange
      cacheHolds(_dashboard());
      await pumpHome(tester);

      // Act
      await tester.tap(tap());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(page), findsOneWidget);
    });
  }

  for (final (name, size) in [
    ('tablet portrait', const Size(834, 1400)),
    ('tablet landscape', const Size(1280, 1000)),
  ]) {
    testWidgets('lays out the dashboard on $name', (tester) async {
      // Arrange
      cacheHolds(_dashboard());

      // Act
      await pumpHome(tester, size: size);

      // Assert
      expect(find.text('Joshua Putra'), findsOneWidget);
      expect(find.text('makan siang 35rb pakai gopay'), findsOneWidget);
      expect(find.text('Change budget'), findsOneWidget);
      expect(find.text('Makan siang'), findsOneWidget);
      expect(find.byTooltip('Search transactions'), findsNothing);
    });
  }
}
