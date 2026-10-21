import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/reports/domain/logic/report_change.dart';
import 'package:monai/features/reports/presentation/model/report_failure.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

part 'report_bloc.freezed.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({
    required DateTime month,
    required this._watchReport,
    required this._refreshReport,
    required this._watchBudget,
    required this._refreshBudget,
    DateTime Function() now = DateTime.now,
  }) : super(_initialState(month, now())) {
    on<_Started>(_onStarted);
    on<_PreviousMonth>(_onPreviousMonth);
    on<_NextMonth>(_onNextMonth);
    on<_Retried>(_onRetried);
    on<_ReportChanged>(_onReportChanged);
    on<_BudgetChanged>(_onBudgetChanged);
  }

  final WatchMonthlyReportUseCase _watchReport;
  final RefreshMonthlyReportUseCase _refreshReport;
  final WatchBudgetUseCase _watchBudget;
  final RefreshBudgetUseCase _refreshBudget;

  StreamSubscription<void>? _report;
  StreamSubscription<void>? _budget;

  // A month in the future shows the current one.
  static ReportState _initialState(DateTime month, DateTime now) {
    final current = DateTime(now.year, now.month);
    final asked = DateTime(month.year, month.month);
    return ReportState(
      month: asked.isAfter(current) ? current : asked,
      currentMonth: current,
    );
  }

  Future<void> _onStarted(_Started event, Emitter<ReportState> emit) =>
      _show(state.month, emit);

  Future<void> _onPreviousMonth(
    _PreviousMonth event,
    Emitter<ReportState> emit,
  ) => _show(state.previousMonth, emit);

  Future<void> _onNextMonth(_NextMonth event, Emitter<ReportState> emit) async {
    if (!state.canShowNextMonth) return;
    await _show(state.nextMonth, emit);
  }

  Future<void> _onRetried(_Retried event, Emitter<ReportState> emit) =>
      _refresh(state.month, emit);

  Future<void> _show(DateTime month, Emitter<ReportState> emit) async {
    await _report?.cancel();
    await _budget?.cancel();
    emit(
      state.copyWith(
        month: month,
        status: UiStatus.loading,
        report: null,
        budget: null,
        loadFailure: null,
        refreshFailure: null,
      ),
    );
    _report = _watchReport(month).listen(
      (result) => result.match(
        (_) {},
        (report) => add(ReportEvent.reportChanged(month, report)),
      ),
    );
    _budget = _watchBudget(month).listen(
      (result) => result.match(
        (_) {},
        (budget) => add(ReportEvent.budgetChanged(month, budget)),
      ),
    );
    await _refresh(month, emit);
  }

  Future<void> _refresh(DateTime month, Emitter<ReportState> emit) async {
    if (state.report == null) {
      emit(state.copyWith(status: UiStatus.loading, loadFailure: null));
    }
    final (report, _) = await (
      _refreshReport(month),
      // Best effort: the budget card keeps its saved copy.
      _refreshBudget(month),
    ).wait;
    // The user moved on to another month meanwhile.
    if (month != state.month) return;
    switch (report) {
      case Right(value: final report):
        emit(state.copyWith(status: UiStatus.success, report: report));
      case Left(value: final failure) when state.report == null:
        emit(
          state.copyWith(
            status: UiStatus.failure,
            loadFailure: ReportFailure.of(failure),
          ),
        );
      case Left(value: final failure):
        emit(state.copyWith(refreshFailure: ReportFailure.of(failure)));
    }
  }

  void _onReportChanged(_ReportChanged event, Emitter<ReportState> emit) {
    final report = event.report;
    if (event.month != state.month || report == null) return;
    emit(
      state.copyWith(
        report: report,
        status: UiStatus.success,
        loadFailure: null,
      ),
    );
  }

  void _onBudgetChanged(_BudgetChanged event, Emitter<ReportState> emit) {
    if (event.month != state.month) return;
    emit(state.copyWith(budget: event.budget));
  }

  @override
  Future<void> close() async {
    await _report?.cancel();
    await _budget?.cancel();
    return super.close();
  }
}
