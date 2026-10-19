import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/monthly_report_dao.dart';
import 'package:monai/core/database/daos/monthly_report_with_categories.dart';

abstract class ReportLocalDataSource {
  /// The report for [month] with its breakdown, or null when none is cached.
  Stream<MonthlyReportWithCategories?> watch(DateTime month);

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
  Future<void> replace(MonthlyReportWithCategories rows) =>
      safeCacheCall(() => _dao.replace(rows.report, rows.categories));
}
