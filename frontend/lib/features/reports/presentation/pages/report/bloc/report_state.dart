part of 'report_bloc.dart';

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({
    required DateTime month,
    required DateTime currentMonth,
    @Default(UiStatus.initial) UiStatus status,
    MonthlyReport? report,
    Budget? budget,
    ReportFailure? loadFailure,
    ReportFailure? refreshFailure,
  }) = _ReportState;
}

extension ReportStateX on ReportState {
  bool get canShowNextMonth => month.isBefore(currentMonth);

  DateTime get previousMonth => DateTime(month.year, month.month - 1);

  DateTime get nextMonth => DateTime(month.year, month.month + 1);

  ReportChange? get expenseChange =>
      ReportChange.of(report?.expenseChangePercent);
}
