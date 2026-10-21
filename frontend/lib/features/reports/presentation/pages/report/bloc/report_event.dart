part of 'report_bloc.dart';

@freezed
sealed class ReportEvent with _$ReportEvent {
  const factory ReportEvent.started() = _Started;
  const factory ReportEvent.previousMonth() = _PreviousMonth;
  const factory ReportEvent.nextMonth() = _NextMonth;
  const factory ReportEvent.retried() = _Retried;

  const factory ReportEvent.reportChanged(
    DateTime month,
    MonthlyReport? report,
  ) = _ReportChanged;

  const factory ReportEvent.budgetChanged(DateTime month, Budget? budget) =
      _BudgetChanged;
}
