import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/reports/domain/logic/report_change.dart';
import 'package:monai/features/reports/presentation/model/report_failure.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/budget_repository.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

import '../../../../../../helpers/entity_fixtures.dart';

class _MockReports extends Mock implements ReportRepository {}

class _MockBudgets extends Mock implements BudgetRepository {}

void main() {
  late _MockReports reports;
  late _MockBudgets budgets;
  late Map<DateTime, StreamController<Either<Failure, MonthlyReport?>>> cached;
  final october = DateTime(2026, 10);
  final september = DateTime(2026, 9);

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    reports = _MockReports();
    budgets = _MockBudgets();
    cached = {};
    when(() => reports.watchMonthlyReport(any())).thenAnswer((invocation) {
      final month = invocation.positionalArguments.single as DateTime;
      final controller = cached.putIfAbsent(month, StreamController.broadcast);
      addTearDown(controller.close);
      return controller.stream;
    });
    when(() => budgets.watchBudget(any()))
        .thenAnswer((_) => Stream.value(const Right<Failure, Budget?>(null)));
    when(() => budgets.refreshBudget(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => reports.refreshMonthlyReport(any())).thenAnswer((invocation) {
      final month = invocation.positionalArguments.single as DateTime;
      return Future.value(Right(monthlyReport(month: month)));
    });
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  Future<ReportBloc> started({DateTime? month}) async {
    final bloc = ReportBloc(
      month: month ?? october,
      watchReport: WatchMonthlyReportUseCase(reports),
      refreshReport: RefreshMonthlyReportUseCase(reports),
      watchBudget: WatchBudgetUseCase(budgets),
      refreshBudget: RefreshBudgetUseCase(budgets),
      now: () => DateTime(2026, 10, 20, 9),
    )..add(const ReportEvent.started());
    addTearDown(bloc.close);
    await settle();
    return bloc;
  }

  Future<void> send(ReportBloc bloc, ReportEvent event) async {
    bloc.add(event);
    await settle();
  }

  test('loads the month and can step back but not forward', () async {
    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.report?.month, october);
    expect(bloc.state.canShowNextMonth, isFalse);
  });

  test('a future month opens on the current one', () async {
    // Act
    final bloc = await started(month: DateTime(2027, 2));

    // Assert
    expect(bloc.state.month, october);
  });

  test('stepping back loads the previous month', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const ReportEvent.previousMonth());

    // Assert
    expect(bloc.state.month, september);
    expect(bloc.state.report?.month, september);
    expect(bloc.state.canShowNextMonth, isTrue);
    verify(() => reports.refreshMonthlyReport(september)).called(1);
    verify(() => budgets.refreshBudget(september)).called(1);
  });

  test('next is ignored on the current month', () async {
    // Arrange
    final bloc = await started();

    // Act
    await send(bloc, const ReportEvent.nextMonth());

    // Assert
    expect(bloc.state.month, october);
  });

  test('an unsaved month that fails to load shows the error', () async {
    // Arrange
    when(() => reports.refreshMonthlyReport(october))
        .thenAnswer((_) async => const Left(Failure.network()));

    // Act
    final bloc = await started();

    // Assert
    expect(bloc.state.status, UiStatus.failure);
    expect(bloc.state.loadFailure, ReportFailure.network);
  });

  test('a saved month that fails to refresh keeps its data', () async {
    // Arrange
    final refresh = Completer<Either<Failure, MonthlyReport>>();
    when(() => reports.refreshMonthlyReport(october))
        .thenAnswer((_) => refresh.future);
    final bloc = await started();

    // Act
    cached[october]!.add(Right(monthlyReport(expenseChangePercent: -10)));
    await settle();
    refresh.complete(const Left(Failure.network()));
    await settle();

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.report, isNotNull);
    expect(bloc.state.refreshFailure, ReportFailure.network);
    expect(bloc.state.expenseChange?.trend, ChangeTrend.less);
  });

  test('a report arriving for a month already left is ignored', () async {
    // Arrange
    final bloc = await started();
    await send(bloc, const ReportEvent.previousMonth());

    // Act
    cached[october]!.add(Right(monthlyReport()));
    await settle();

    // Assert
    expect(bloc.state.report?.month, september);
  });

  test('retry after a failed load shows the month', () async {
    // Arrange
    var calls = 0;
    when(() => reports.refreshMonthlyReport(october)).thenAnswer(
      (_) async => calls++ == 0
          ? const Left(Failure.server(500))
          : Right(monthlyReport()),
    );
    final bloc = await started();
    expect(bloc.state.loadFailure, ReportFailure.unexpected);

    // Act
    await send(bloc, const ReportEvent.retried());

    // Assert
    expect(bloc.state.status, UiStatus.success);
    expect(bloc.state.loadFailure, isNull);
  });
}
