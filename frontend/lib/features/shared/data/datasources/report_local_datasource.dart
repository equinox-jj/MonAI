import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/monthly_report_dao.dart';
import 'package:monai/core/data/database/daos/monthly_report_with_categories.dart';
import 'package:monai/core/data/database/monai_database.dart';

abstract class ReportLocalDataSource {
  Stream<MonthlyReportWithCategories?> watch(DateTime month);

  Stream<List<MonthlyReportRow>> watchBetween(DateTime from, DateTime to);

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
