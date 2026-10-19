import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';

/// Re-fetches the report of a month (the first of the month).
class RefreshMonthlyReportUseCase implements UseCase<MonthlyReport, DateTime> {
  RefreshMonthlyReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Either<Failure, MonthlyReport>> call(DateTime month) =>
      _repository.refreshMonthlyReport(month);
}
