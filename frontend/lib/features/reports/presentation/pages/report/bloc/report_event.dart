part of 'report_bloc.dart';

@freezed
sealed class ReportEvent with _$ReportEvent {
  /// The screen opened.
  const factory ReportEvent.started() = _Started;

  /// The previous-month arrow.
  const factory ReportEvent.previousMonth() = _PreviousMonth;

  /// The next-month arrow; ignored on the current month.
  const factory ReportEvent.nextMonth() = _NextMonth;

  /// "Try again" after the report couldn't be loaded.
  const factory ReportEvent.retried() = _Retried;

  /// The cached report of [month] changed. Sent by the bloc itself.
  const factory ReportEvent.reportChanged(
    DateTime month,
    MonthlyReport? report,
  ) = _ReportChanged;

  /// The cached budget of [month] changed. Sent by the bloc itself.
  const factory ReportEvent.budgetChanged(DateTime month, Budget? budget) =
      _BudgetChanged;
}
