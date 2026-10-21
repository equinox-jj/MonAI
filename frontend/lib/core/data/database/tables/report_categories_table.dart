import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/data/database/tables/monthly_reports_table.dart';

/// One row of a report's expense breakdown; [position] keeps the server's
/// order. Deleted with its report.
@DataClassName('ReportCategoryRow')
class ReportCategories extends Table {
  TextColumn get month => text()
      .map(const YearMonthConverter())
      .references(MonthlyReports, #month, onDelete: KeyAction.cascade)();
  TextColumn get categoryId => text()();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();

  /// Rupiah.
  IntColumn get amount => integer()();
  RealColumn get sharePercent => real()();

  /// Rupiah.
  IntColumn get previousAmount => integer()();

  /// Null when the category had no expenses the previous month.
  RealColumn get changePercent => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {month, categoryId};
}
