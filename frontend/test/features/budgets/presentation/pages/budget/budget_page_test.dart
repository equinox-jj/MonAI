import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/budgets/domain/usecase/delete_budget_usecase.dart';
import 'package:monai/features/budgets/domain/usecase/set_budget_usecase.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';
import 'package:monai/features/budgets/presentation/pages/budget/budget_page.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

import '../../../../../helpers/entity_fixtures.dart';

class _MockBudgets extends Mock implements BudgetRepository {}

class _MockReports extends Mock implements ReportRepository {}

void main() {
  final october = DateTime(2026, 10);

  Future<void> pumpBudget(WidgetTester tester, {Budget? saved}) async {
    tester.view
      ..physicalSize = const Size(390, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final budgets = _MockBudgets();
    final reports = _MockReports();
    when(() => budgets.watchBudget(october))
        .thenAnswer((_) => Stream.value(Right(saved)));
    when(() => budgets.refreshBudget(october))
        .thenAnswer((_) async => Right(saved));
    when(() => reports.watchMonthlyReport(october))
        .thenAnswer((_) => Stream.value(Right(monthlyReport())));
    when(() => reports.refreshMonthlyReport(october))
        .thenAnswer((_) async => Right(monthlyReport()));
    final bloc = BudgetBloc(
      month: october,
      watchBudget: WatchBudgetUseCase(budgets),
      refreshBudget: RefreshBudgetUseCase(budgets),
      watchReport: WatchMonthlyReportUseCase(reports),
      refreshReport: RefreshMonthlyReportUseCase(reports),
      setBudget: SetBudgetUseCase(budgets),
      deleteBudget: DeleteBudgetUseCase(budgets),
    )..add(const BudgetEvent.started());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MonAITheme.light(),
        home: BlocProvider.value(value: bloc, child: const BudgetUI()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a saved budget fills the field and can be removed', (
    tester,
  ) async {
    // Act
    await pumpBudget(tester, saved: budget());

    // Assert
    expect(find.text('October budget'), findsOneWidget);
    expect(find.text('1.000.000'), findsOneWidget);
    expect(find.text('Rp 250.000 spent'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Rp 750.000 left'), findsOneWidget);
    expect(find.text('Remove budget for October'), findsOneWidget);
  });

  testWidgets('without a budget there is no preview until a limit is picked', (
    tester,
  ) async {
    // Arrange
    await pumpBudget(tester);
    expect(find.text('Remove budget for October'), findsNothing);
    expect(find.text("Preview with this month's spending"), findsNothing);

    // Act
    await tester.tap(find.text('2 jt'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('2.000.000'), findsOneWidget);
    expect(find.text("Preview with this month's spending"), findsOneWidget);
    expect(find.text('Rp 1.750.000 left'), findsOneWidget);
  });
}
