import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/data/database/daos/monthly_report_with_categories.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/database/tables/monthly_reports_table.dart';
import 'package:monai/core/data/database/tables/report_categories_table.dart';

part 'monthly_report_dao.g.dart';

@DriftAccessor(tables: [MonthlyReports, ReportCategories])
class MonthlyReportDao extends DatabaseAccessor<MonAIDatabase>
    with _$MonthlyReportDaoMixin {
  MonthlyReportDao(super.attachedDatabase);

  Stream<MonthlyReportWithCategories?> watch(DateTime month) {
    final query =
        select(monthlyReports).join([
            leftOuterJoin(
              reportCategories,
              reportCategories.month.equalsExp(monthlyReports.month),
            ),
          ])
          ..where(monthlyReports.month.equalsValue(month))
          ..orderBy([OrderingTerm.asc(reportCategories.position)]);
    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      return (
        report: rows.first.readTable(monthlyReports),
        categories: rows
            .map((row) => row.readTableOrNull(reportCategories))
            .nonNulls
            .toList(),
      );
    });
  }

  Stream<List<MonthlyReportRow>> watchBetween(DateTime from, DateTime to) {
    const converter = YearMonthConverter();
    return (select(monthlyReports)
          ..where(
            (t) => t.month.isBetweenValues(
              converter.toSql(from),
              converter.toSql(to),
            ),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.month)]))
        .watch();
  }

  Future<void> replace(
    MonthlyReportRow report,
    List<ReportCategoryRow> categories,
  ) => transaction(() async {
    await into(monthlyReports)
        .insertOnConflictUpdate(report.toCompanion(false));
    await (delete(
      reportCategories,
    )..where((t) => t.month.equalsValue(report.month))).go();
    await batch((b) => b.insertAll(reportCategories, categories));
  });

  Future<void> deleteByMonth(DateTime month) =>
      (delete(monthlyReports)..where((t) => t.month.equalsValue(month))).go();
}
