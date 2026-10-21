import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';

/// The report of a month (the first of the month); null until fetched.
class WatchMonthlyReportUseCase
    implements StreamUseCase<MonthlyReport?, DateTime> {
  WatchMonthlyReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Stream<Either<Failure, MonthlyReport?>> call(DateTime month) =>
      _repository.watchMonthlyReport(month);
}
