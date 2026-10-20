import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/budgets/domain/logic/budget_preview.dart';
import 'package:monai/features/budgets/domain/usecase/delete_budget_usecase.dart';
import 'package:monai/features/budgets/domain/usecase/set_budget_usecase.dart';
import 'package:monai/features/budgets/domain/validation/budget_limit_rule.dart';
import 'package:monai/features/budgets/presentation/model/budget_failure.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/usecase/refresh_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/refresh_monthly_report_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_budget_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_monthly_report_usecase.dart';

part 'budget_bloc.freezed.dart';
part 'budget_event.dart';
part 'budget_state.dart';

/// A month's budget: set, change or remove its limit, previewed against the
/// month's spending. The limit lives in the screen's text field and arrives
/// with each edit and with save.
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc({
    required DateTime month,
    required this._watchBudget,
    required this._refreshBudget,
    required this._watchReport,
    required this._refreshReport,
    required this._setBudget,
    required this._deleteBudget,
  }) : super(BudgetState(month: DateTime(month.year, month.month))) {
    on<_Started>(_onStarted);
    on<_LimitEdited>(_onLimitEdited);
    on<_SaveRequested>(_onSaveRequested);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_BudgetChanged>(_onBudgetChanged);
    on<_ReportChanged>(_onReportChanged);
  }

  final WatchBudgetUseCase _watchBudget;
  final RefreshBudgetUseCase _refreshBudget;
  final WatchMonthlyReportUseCase _watchReport;
  final RefreshMonthlyReportUseCase _refreshReport;
  final SetBudgetUseCase _setBudget;
  final DeleteBudgetUseCase _deleteBudget;

  StreamSubscription<void>? _budget;
  StreamSubscription<void>? _report;

  Future<void> _onStarted(_Started event, Emitter<BudgetState> emit) async {
    _budget = _watchBudget(state.month).listen(
      (result) => result.match(
        (_) {},
        (budget) => add(BudgetEvent.budgetChanged(budget)),
      ),
    );
    _report = _watchReport(state.month).listen(
      (result) => result.match(
        (_) {},
        (report) => add(BudgetEvent.reportChanged(report)),
      ),
    );
    // Best effort: the cached copies stay on failure.
    await Future.wait([
      _refreshBudget(state.month),
      _refreshReport(state.month),
    ]);
  }

  void _onBudgetChanged(_BudgetChanged event, Emitter<BudgetState> emit) {
    final budget = event.budget;
    emit(
      state.copyWith(
        budget: budget,
        limit: state.limitTouched ? state.limit : budget?.limitAmount ?? 0,
      ),
    );
  }

  void _onReportChanged(_ReportChanged event, Emitter<BudgetState> emit) =>
      emit(state.copyWith(reportSpent: event.report?.expenseTotal));

  void _onLimitEdited(_LimitEdited event, Emitter<BudgetState> emit) {
    final limit = parseRupiahInput(event.limit);
    emit(
      state.copyWith(
        limit: limit,
        limitTouched: true,
        limitError: state.autovalidate ? BudgetLimitRule.check(limit) : null,
      ),
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.isBusy) return;
    final limit = parseRupiahInput(event.limit);
    emit(
      state.copyWith(
        limit: limit,
        isSaving: true,
        limitError: null,
        actionFailure: null,
      ),
    );
    final result = await _setBudget((month: state.month, limit: limit));
    switch (result) {
      case Right():
        emit(state.copyWith(isSaving: false, outcome: BudgetOutcome.saved));
      case Left(value: final failure):
        emit(_failed(state.copyWith(isSaving: false), failure));
    }
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<BudgetState> emit,
  ) async {
    if (state.isBusy || !state.hasBudget) return;
    emit(state.copyWith(isDeleting: true, actionFailure: null));
    final result = await _deleteBudget(state.month);
    switch (result) {
      case Right():
        emit(state.copyWith(isDeleting: false, outcome: BudgetOutcome.removed));
      case Left(value: final failure):
        emit(_failed(state.copyWith(isDeleting: false), failure));
    }
  }

  BudgetState _failed(BudgetState state, Failure failure) {
    final limitError = switch (failure) {
      ValidationFailure(:final fieldErrors) => fieldErrors.firstForField(
        BudgetLimitRule.field,
      ),
      _ => null,
    };
    if (limitError != null) {
      return state.copyWith(limitError: limitError, autovalidate: true);
    }
    return state.copyWith(actionFailure: BudgetFailure.of(failure));
  }

  @override
  Future<void> close() async {
    await _budget?.cancel();
    await _report?.cancel();
    return super.close();
  }
}
