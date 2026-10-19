import 'package:drift/drift.dart';
import 'package:monai/core/database/converters.dart';

/// A month's totals, compared with the month before it.
@DataClassName('MonthlyReportRow')
class MonthlyReports extends Table {
  TextColumn get month => text().map(const YearMonthConverter())();

  /// Rupiah.
  IntColumn get incomeTotal => integer()();

  /// Rupiah.
  IntColumn get expenseTotal => integer()();

  /// Rupiah, income minus expenses.
  IntColumn get net => integer()();
  TextColumn get previousMonth => text().map(const YearMonthConverter())();
  IntColumn get previousIncomeTotal => integer()();
  IntColumn get previousExpenseTotal => integer()();

  /// Null when the previous month had no expenses.
  RealColumn get expenseChangePercent => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {month};
}
