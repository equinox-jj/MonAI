import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

abstract class ReportRepository {
  Stream<Either<Failure, MonthlyReport?>> watchMonthlyReport(DateTime month);

  Future<Either<Failure, MonthlyReport>> refreshMonthlyReport(DateTime month);

  /// Keyed by the first of the month; months without a cached report are
  /// missing.
  Stream<Either<Failure, Map<DateTime, int>>> watchExpenseTotals(int year);
}
