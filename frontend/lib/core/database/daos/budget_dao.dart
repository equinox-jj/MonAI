import 'package:drift/drift.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/database/tables/budgets_table.dart';

part 'budget_dao.g.dart';

/// Reads and writes the cached monthly budgets.
@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<MonAIDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.attachedDatabase);

  /// The budget for [month], or null when none is cached.
  Stream<BudgetRow?> watch(DateTime month) => (select(
    budgets,
  )..where((t) => t.month.equalsValue(month))).watchSingleOrNull();

  Future<void> upsert(BudgetRow row) =>
      into(budgets).insertOnConflictUpdate(row.toCompanion(false));

  Future<void> deleteByMonth(DateTime month) =>
      (delete(budgets)..where((t) => t.month.equalsValue(month))).go();
}
