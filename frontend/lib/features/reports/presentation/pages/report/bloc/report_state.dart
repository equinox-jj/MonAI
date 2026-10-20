part of 'report_bloc.dart';

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({
    /// The first of the shown month.
    required DateTime month,

    /// The first of this month: the latest month the report shows.
    required DateTime currentMonth,

    /// [UiStatus.loading] while a month without a saved report loads,
    /// [UiStatus.failure] when it couldn't be, otherwise
    /// [UiStatus.success].
    @Default(UiStatus.initial) UiStatus status,

    /// The month's report; null until loaded.
    MonthlyReport? report,

    /// The month's budget; null when none is set.
    Budget? budget,

    /// Why the report couldn't be loaded.
    ReportFailure? loadFailure,

    /// Why a saved report couldn't be refreshed; shown once as a snackbar.
    ReportFailure? refreshFailure,
  }) = _ReportState;
}

extension ReportStateX on ReportState {
  bool get canShowNextMonth => month.isBefore(currentMonth);

  /// The month before the shown one.
  DateTime get previousMonth => DateTime(month.year, month.month - 1);

  /// The month after the shown one.
  DateTime get nextMonth => DateTime(month.year, month.month + 1);

  /// The month's expenses against the month before's.
  ReportChange? get expenseChange =>
      ReportChange.of(report?.expenseChangePercent);
}
