import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/model/budget_status.dart';

@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get month => text().map(const YearMonthConverter())();

  IntColumn get limitAmount => integer()();

  IntColumn get spent => integer()();

  IntColumn get remaining => integer()();
  RealColumn get progressPercent => real()();
  TextColumn get status => textEnum<BudgetStatus>()();

  @override
  Set<Column<Object>> get primaryKey => {month};
}
