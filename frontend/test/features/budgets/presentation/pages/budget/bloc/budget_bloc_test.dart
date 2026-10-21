import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/features/budgets/domain/usecase/delete_budget_usecase.dart';
import 'package:monai/features/budgets/domain/usecase/set_budget_usecase.dart';
import 'package:monai/features/budgets/domain/validation/budget_limit_rule.dart';
import 'package:monai/features/budgets/presentation/model/budget_failure.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockBudgets extends Mock implements BudgetRepository {}

class _MockReports extends Mock implements ReportRepository {}

void main() {
  late _MockBudgets budgets;
  late _MockReports reports;
  late StreamController<Either<Failure, Budget?>> cachedBudget;
  late StreamController<Either<Failure, MonthlyReport?>> cachedReport;
  final october = DateTime(2026, 10);

  setUp(() {
    budgets = _MockBudgets();
    reports = _MockReports();
    cachedBudget = StreamController.broadcast();
    cachedReport = StreamController.broadcast();
    addTearDown(cachedBudget.close);
    addTearDown(cachedReport.close);
    when(() => budgets.watchBudget(october))
        .thenAnswer((_) => cachedBudget.stream);
    when(() => reports.watchMonthlyReport(october))
        .thenAnswer((_) => cachedReport.stream);
    when(() => budgets.refreshBudget(october))
        .thenAnswer((_) async => const Right(null));
    when(() => reports.refreshMonthlyReport(october))
        .thenAnswer((_) async => Right(monthlyReport()));
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  Future<BudgetBloc> started() async {
    final bloc = BudgetBloc(
      // Any day of the month opens the month.
      month: DateTime(2026, 10, 20),
      watchBudget: WatchBudgetUseCase(budgets),
      refreshBudget: RefreshBudgetUseCase(budgets),
      watchReport: WatchMonthlyReportUseCase(reports),
      refreshReport: RefreshMonthlyReportUseCase(reports),
      setBudget: SetBudgetUseCase(budgets),
      deleteBudget: DeleteBudgetUseCase(budgets),
    )..add(const BudgetEvent.started());
    addTearDown(bloc.close);
    await settle();
    return bloc;
  }

  Future<void> send(BudgetBloc bloc, BudgetEvent event) async {
    bloc.add(event);
    await settle();
  }

  test('starts with the saved limit and refreshes both', () async {
    // Arrange
    final bloc = await started();

    // Act
    cachedBudget.add(Right(budget()));
    await settle();

    // Assert
    expect(bloc.state.month, october);
    expect(bloc.state.hasBudget, isTrue);
    expect(bloc.state.limit, 1000000);
    expect(bloc.state.preview?.status, BudgetStatus.ok);
    verify(() => budgets.refreshBudget(october)).called(1);
    verify(() => reports.refreshMonthlyReport(october)).called(1);
  });

  test("without a budget, the preview uses the report's spending", () async {
    // Arrange
    final bloc = await started();
    cachedBudget.add(const Right(null));
    cachedReport.add(Right(monthlyReport()));
    await settle();

    // Act
    await send(bloc, const BudgetEvent.limitEdited('300.000'));

    // Assert
    expect(bloc.state.hasBudget, isFalse);
    expect(bloc.state.limit, 300000);
    expect(bloc.state.spent, 250000);
    expect(bloc.state.preview?.status, BudgetStatus.warning);
  });

  test('a budget arriving late keeps what the user typed', () async {
    // Arrange
    final bloc = await started();
    await send(bloc, const BudgetEvent.limitEdited('2.000.000'));

    // Act
    cachedBudget.add(Right(budget()));
    await settle();

    // Assert
    expect(bloc.state.limit, 2000000);
    expect(bloc.state.hasBudget, isTrue);
  });

  test('saving sends the limit and closes', () async {
    // Arrange
    when(() => budgets.setBudget(october, 3000000))
        .thenAnswer((_) async => Right(budget()));
    final bloc = await started();

    // Act
    await send(bloc, const BudgetEvent.saveRequested('3.000.000'));

    // Assert
    expect(bloc.state.outcome, BudgetOutcome.saved);
    expect(bloc.state.isSaving, isFalse);
  });

  test(
    'an empty limit shows the error, then re-checks as it is typed',
    () async {
      // Arrange
      final bloc = await started();

      // Act
      await send(bloc, const BudgetEvent.saveRequested(''));

      // Assert
      expect(bloc.state.limitError?.field, BudgetLimitRule.field);
      expect(bloc.state.autovalidate, isTrue);
      expect(bloc.state.outcome, isNull);

      // Act
      await send(bloc, const BudgetEvent.limitEdited('5'));

      // Assert
      expect(bloc.state.limitError, isNull);
    },
  );

  test('a failed save keeps the screen open and says why', () async {
    // Arrange
    when(() => budgets.setBudget(any(), any()))
        .thenAnswer((_) async => const Left(Failure.network()));
    final bloc = await started();

    // Act
    await send(bloc, const BudgetEvent.saveRequested('3.000.000'));

    // Assert
    expect(bloc.state.actionFailure, BudgetFailure.network);
    expect(bloc.state.outcome, isNull);
  });

  test('removing a saved budget closes', () async {
    // Arrange
    when(() => budgets.deleteBudget(october))
        .thenAnswer((_) async => const Right(unit));
    final bloc = await started();
    cachedBudget.add(Right(budget()));
    await settle();

    // Act
    await send(bloc, const BudgetEvent.deleteRequested());

    // Assert
    expect(bloc.state.outcome, BudgetOutcome.removed);
  });

  test('a month without a budget has nothing to remove', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const BudgetEvent.deleteRequested());

    // Assert
    verifyNever(() => budgets.deleteBudget(any()));
    expect(bloc.state.outcome, isNull);
  });
}
