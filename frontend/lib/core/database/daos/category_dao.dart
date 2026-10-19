import 'package:drift/drift.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/database/tables/categories_table.dart';
import 'package:monai/core/model/category_type.dart';

part 'category_dao.g.dart';

/// Reads and writes the cached categories.
@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<MonAIDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.attachedDatabase);

  /// Every category, by name.
  Stream<List<CategoryRow>> watchAll() =>
      (select(
            categories,
          )..orderBy([(t) => OrderingTerm.asc(t.name.collate(Collate.noCase))]))
          .watch();

  /// The categories of [type], by name.
  Stream<List<CategoryRow>> watchByType(CategoryType type) =>
      (select(categories)
            ..where((t) => t.type.equalsValue(type))
            ..orderBy([
              (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
            ]))
          .watch();

  Future<void> upsertAll(List<CategoryRow> rows) => batch(
    (b) => b.insertAllOnConflictUpdate(
      categories,
      rows.map((row) => row.toCompanion(false)),
    ),
  );

  Future<void> deleteById(String id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  /// Swaps in a full list from the server, dropping categories it no longer
  /// returns.
  Future<void> replaceAll(List<CategoryRow> rows) => transaction(() async {
    await delete(categories).go();
    await upsertAll(rows);
  });
}
