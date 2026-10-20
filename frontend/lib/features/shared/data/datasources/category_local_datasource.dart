import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/category_dao.dart';
import 'package:monai/core/database/daos/transaction_dao.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/category_type.dart';

abstract class CategoryLocalDataSource {
  /// Every cached category, hidden ones included, by name.
  Stream<List<CategoryRow>> watchAll();

  /// The cached categories of [type], hidden ones included, by name.
  Stream<List<CategoryRow>> watchByType(CategoryType type);

  /// The cached category [id], or null.
  Future<CategoryRow?> find(String id);

  /// Replaces the whole cache with the server's list.
  Future<void> replaceAll(List<CategoryRow> rows);

  /// Adds or replaces one category.
  Future<void> save(CategoryRow row);

  /// Drops category [id], moving its cached transactions to [moveTo] when
  /// given, as the server did.
  Future<void> delete(String id, {String? moveTo});
}

class CategoryLocalDataSourceImpl extends CategoryLocalDataSource
    with BaseLocalDataSource {
  CategoryLocalDataSourceImpl({
    required this._dao,
    required this._transactionDao,
  });

  final CategoryDao _dao;
  final TransactionDao _transactionDao;

  @override
  Stream<List<CategoryRow>> watchAll() => safeCacheStream(_dao.watchAll);

  @override
  Stream<List<CategoryRow>> watchByType(CategoryType type) =>
      safeCacheStream(() => _dao.watchByType(type));

  @override
  Future<CategoryRow?> find(String id) => safeCacheCall(() => _dao.find(id));

  @override
  Future<void> replaceAll(List<CategoryRow> rows) =>
      safeCacheCall(() => _dao.replaceAll(rows));

  @override
  Future<void> save(CategoryRow row) =>
      safeCacheCall(() => _dao.upsertAll([row]));

  @override
  Future<void> delete(String id, {String? moveTo}) => safeCacheCall(
    () => _dao.transaction(() async {
      if (moveTo != null) await _transactionDao.moveCategory(id, moveTo);
      await _dao.deleteById(id);
    }),
  );
}
