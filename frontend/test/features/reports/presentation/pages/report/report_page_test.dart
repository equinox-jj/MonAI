import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/reports/presentation/pages/report/report_page.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockReports extends Mock implements ReportRepository {}

class _MockBudgets extends Mock implements BudgetRepository {}

void main() {
  final october = DateTime(2026, 10);

  Future<void> pumpReport(
    WidgetTester tester, {
    Either<Failure, MonthlyReport> refreshed = const Left(Failure.network()),
    MonthlyReport? saved,
    Budget? budget,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final reports = _MockReports();
    final budgets = _MockBudgets();
    when(() => reports.watchMonthlyReport(october))
        .thenAnswer((_) => Stream.value(Right(saved)));
    when(() => reports.refreshMonthlyReport(october))
        .thenAnswer((_) async => refreshed);
    when(() => budgets.watchBudget(october))
        .thenAnswer((_) => Stream.value(Right(budget)));
    when(() => budgets.refreshBudget(october))
        .thenAnswer((_) async => Right(budget));
    final bloc = ReportBloc(
      month: october,
      watchReport: WatchMonthlyReportUseCase(reports),
      refreshReport: RefreshMonthlyReportUseCase(reports),
      watchBudget: WatchBudgetUseCase(budgets),
      refreshBudget: RefreshBudgetUseCase(budgets),
      now: () => DateTime(2026, 10, 20),
    )..add(const ReportEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const ReportUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the totals, the breakdown and the budget', (tester) async {
    // Arrange
    final report = monthlyReport(
      expenseChangePercent: -10,
      categories: [
        categoryBreakdown(amount: 150000, sharePercent: 60, changePercent: -5),
        categoryBreakdown(
          id: 'c2',
          name: 'Transport',
          amount: 100000,
          changePercent: 11,
        ),
      ],
    );

    // Act
    await pumpReport(tester, refreshed: Right(report), budget: budget());

    // Assert
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('+Rp 5.000.000'), findsOneWidget);
    expect(find.text('−Rp 250.000'), findsOneWidget);
    expect(find.text('+Rp 4.750.000'), findsOneWidget);
    expect(find.text('Spent 10% less than Sep'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('60% of spending'), findsOneWidget);
    expect(find.text('↓ 5% vs Sep'), findsOneWidget);
    expect(find.text('↑ 11% vs Sep'), findsOneWidget);
    expect(find.text('25% of Rp 1.000.000'), findsOneWidget);
    expect(find.text('Rp 750.000 left'), findsOneWidget);
  });

  testWidgets('a month without spending or budget says so', (tester) async {
    // Act
    await pumpReport(tester, refreshed: Right(monthlyReport()));

    // Assert
    expect(find.text('No spending in October'), findsOneWidget);
    expect(find.text('No budget for October'), findsOneWidget);
  });

  testWidgets('a month that never loaded offers to try again', (tester) async {
    // Act
    await pumpReport(tester);

    // Assert
    expect(find.text("Couldn't load the report"), findsOneWidget);
    expect(
      find.text("You're offline. Connect to the internet to load this month."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });
}
