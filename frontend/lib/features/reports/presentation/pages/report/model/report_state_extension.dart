import 'package:monai/features/reports/domain/logic/report_change.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';

extension ReportStateX on ReportState {
  bool get canShowNextMonth => month.isBefore(currentMonth);

  DateTime get previousMonth => DateTime(month.year, month.month - 1);

  DateTime get nextMonth => DateTime(month.year, month.month + 1);

  ReportChange? get expenseChange =>
      ReportChange.of(report?.expenseChangePercent);
}
