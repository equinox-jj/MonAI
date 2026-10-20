part of 'budget_bloc.dart';

@freezed
sealed class BudgetEvent with _$BudgetEvent {
  /// The screen opened.
  const factory BudgetEvent.started() = _Started;

  /// The limit field's text changed, typed or from a preset.
  const factory BudgetEvent.limitEdited(String limit) = _LimitEdited;

  /// "Save budget", with the limit field's text.
  const factory BudgetEvent.saveRequested(String limit) = _SaveRequested;

  /// "Remove budget", once confirmed.
  const factory BudgetEvent.deleteRequested() = _DeleteRequested;

  /// The cached budget changed. Sent by the bloc itself.
  const factory BudgetEvent.budgetChanged(Budget? budget) = _BudgetChanged;

  /// The cached report changed, for the month's spending. Sent by the bloc
  /// itself.
  const factory BudgetEvent.reportChanged(MonthlyReport? report) =
      _ReportChanged;
}
