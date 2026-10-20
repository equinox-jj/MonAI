import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/data/datasources/report_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/report_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/monthly_report_mapper.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/repository/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository with BaseRepository {
  ReportRepositoryImpl({required this._remote, required this._local});

  final ReportRemoteDataSource _remote;
  final ReportLocalDataSource _local;

  @override
  Stream<Either<Failure, MonthlyReport?>> watchMonthlyReport(DateTime month) =>
      safeStream(() => _local.watch(month).map((rows) => rows?.toEntity()));

  @override
  Future<Either<Failure, MonthlyReport>> refreshMonthlyReport(DateTime month) =>
      safeCall(() async {
        final response = await _remote.getMonthlyReport(formatApiMonth(month));
        final rows = requireField(response.data).toRows();
        await _local.replace(rows);
        return rows.toEntity();
      });

  @override
  Stream<Either<Failure, Map<DateTime, int>>> watchExpenseTotals(int year) =>
      safeStream(
        () => _local
            .watchBetween(DateTime(year), DateTime(year, 12))
            .map(
              (rows) => {for (final row in rows) row.month: row.expenseTotal},
            ),
      );
}
