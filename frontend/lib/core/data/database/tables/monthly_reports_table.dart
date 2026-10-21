import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';

@DataClassName('MonthlyReportRow')
class MonthlyReports extends Table {
  TextColumn get month => text().map(const YearMonthConverter())();

  IntColumn get incomeTotal => integer()();

  IntColumn get expenseTotal => integer()();

  IntColumn get net => integer()();
  TextColumn get previousMonth => text().map(const YearMonthConverter())();
  IntColumn get previousIncomeTotal => integer()();
  IntColumn get previousExpenseTotal => integer()();

  RealColumn get expenseChangePercent => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {month};
}
