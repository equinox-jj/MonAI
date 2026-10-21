import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/budget_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';

abstract class BudgetLocalDataSource {
  /// The budget for [month], or null when none is cached.
  Stream<BudgetRow?> watch(DateTime month);

  Future<void> upsert(BudgetRow row);

  Future<void> deleteByMonth(DateTime month);
}

class BudgetLocalDataSourceImpl extends BudgetLocalDataSource
    with BaseLocalDataSource {
  BudgetLocalDataSourceImpl({required this._dao});

  final BudgetDao _dao;

  @override
  Stream<BudgetRow?> watch(DateTime month) =>
      safeCacheStream(() => _dao.watch(month));

  @override
  Future<void> upsert(BudgetRow row) => safeCacheCall(() => _dao.upsert(row));

  @override
  Future<void> deleteByMonth(DateTime month) =>
      safeCacheCall(() => _dao.deleteByMonth(month));
}
