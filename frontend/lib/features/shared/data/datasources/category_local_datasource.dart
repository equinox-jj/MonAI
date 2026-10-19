import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/category_dao.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/category_type.dart';

abstract class CategoryLocalDataSource {
  /// Every cached category, hidden ones included, by name.
  Stream<List<CategoryRow>> watchAll();

  /// The cached categories of [type], hidden ones included, by name.
  Stream<List<CategoryRow>> watchByType(CategoryType type);

  /// Replaces the whole cache with the server's list.
  Future<void> replaceAll(List<CategoryRow> rows);
}

class CategoryLocalDataSourceImpl extends CategoryLocalDataSource
    with BaseLocalDataSource {
  CategoryLocalDataSourceImpl({required this._dao});

  final CategoryDao _dao;

  @override
  Stream<List<CategoryRow>> watchAll() => safeCacheStream(_dao.watchAll);

  @override
  Stream<List<CategoryRow>> watchByType(CategoryType type) =>
      safeCacheStream(() => _dao.watchByType(type));

  @override
  Future<void> replaceAll(List<CategoryRow> rows) =>
      safeCacheCall(() => _dao.replaceAll(rows));
}
