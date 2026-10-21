import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';

/// Monthly income and expense reports.
abstract class ReportRepository {
  /// The report for [month] (the first of the month), or null when none is
  /// cached.
  Stream<Either<Failure, MonthlyReport?>> watchMonthlyReport(DateTime month);

  /// Re-fetches the report for [month] and gives the cached copy.
  Future<Either<Failure, MonthlyReport>> refreshMonthlyReport(DateTime month);

  /// The expense total of each cached month of [year], keyed by the first of
  /// the month; months without a cached report are missing.
  Stream<Either<Failure, Map<DateTime, int>>> watchExpenseTotals(int year);
}
