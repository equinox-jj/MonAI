part of 'budget_bloc.dart';

@freezed
sealed class BudgetEvent with _$BudgetEvent {
  const factory BudgetEvent.started() = _Started;
  const factory BudgetEvent.limitEdited(String limit) = _LimitEdited;
  const factory BudgetEvent.saveRequested(String limit) = _SaveRequested;
  const factory BudgetEvent.deleteRequested() = _DeleteRequested;
  const factory BudgetEvent.budgetChanged(Budget? budget) = _BudgetChanged;

  const factory BudgetEvent.reportChanged(MonthlyReport? report) =
      _ReportChanged;
}
