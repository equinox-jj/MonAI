import 'package:monai/core/app/injector.dart';
import 'package:monai/features/reports/presentation/pages/report/bloc/report_bloc.dart';

class ReportsDI {
  ReportsDI._();

  static Future<void> init() async {
    sl.registerFactoryParam<ReportBloc, DateTime, void>(
      (month, _) => ReportBloc(
        month: month,
        watchReport: sl(),
        refreshReport: sl(),
        watchBudget: sl(),
        refreshBudget: sl(),
      ),
    );
  }
}
