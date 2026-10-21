import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/model/budget_status.dart';

/// One budget per month, its progress calculated by the server.
@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get month => text().map(const YearMonthConverter())();

  /// Rupiah.
  IntColumn get limitAmount => integer()();

  /// Rupiah, the month's expenses.
  IntColumn get spent => integer()();

  /// Rupiah; negative when over budget.
  IntColumn get remaining => integer()();
  RealColumn get progressPercent => real()();
  TextColumn get status => textEnum<BudgetStatus>()();

  @override
  Set<Column<Object>> get primaryKey => {month};
}
