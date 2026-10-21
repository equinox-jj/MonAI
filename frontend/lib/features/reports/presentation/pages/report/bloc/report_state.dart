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
