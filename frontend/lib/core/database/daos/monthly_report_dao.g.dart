// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_dao.dart';

// ignore_for_file: type=lint
mixin _$MonthlyReportDaoMixin on DatabaseAccessor<MonAIDatabase> {
  $MonthlyReportsTable get monthlyReports => attachedDatabase.monthlyReports;
  $ReportCategoriesTable get reportCategories =>
      attachedDatabase.reportCategories;
  MonthlyReportDaoManager get managers => MonthlyReportDaoManager(this);
}

class MonthlyReportDaoManager {
  final _$MonthlyReportDaoMixin _db;
  MonthlyReportDaoManager(this._db);
  $$MonthlyReportsTableTableManager get monthlyReports =>
      $$MonthlyReportsTableTableManager(
        _db.attachedDatabase,
        _db.monthlyReports,
      );
  $$ReportCategoriesTableTableManager get reportCategories =>
      $$ReportCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.reportCategories,
      );
}
