import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/monthly_report_dao.dart';
import 'package:monai/core/database/daos/monthly_report_with_categories.dart';
import 'package:monai/core/database/monai_database.dart';

abstract class ReportLocalDataSource {
  /// The report for [month] with its breakdown, or null when none is cached.
  Stream<MonthlyReportWithCategories?> watch(DateTime month);

  /// The reports cached for the months from [from] to [to], without their
  /// breakdowns, oldest first.
  Stream<List<MonthlyReportRow>> watchBetween(DateTime from, DateTime to);

  /// Replaces a month's report and its whole breakdown.
  Future<void> replace(MonthlyReportWithCategories rows);
}

class ReportLocalDataSourceImpl extends ReportLocalDataSource
    with BaseLocalDataSource {
  ReportLocalDataSourceImpl({required this._dao});

  final MonthlyReportDao _dao;

  @override
  Stream<MonthlyReportWithCategories?> watch(DateTime month) =>
      safeCacheStream(() => _dao.watch(month));

  @override
  Stream<List<MonthlyReportRow>> watchBetween(DateTime from, DateTime to) =>
      safeCacheStream(() => _dao.watchBetween(from, to));

  @override
  Future<void> replace(MonthlyReportWithCategories rows) =>
      safeCacheCall(() => _dao.replace(rows.report, rows.categories));
}
