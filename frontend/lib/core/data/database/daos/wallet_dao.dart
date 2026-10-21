import 'package:drift/drift.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/database/tables/wallets_table.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<MonAIDatabase> with _$WalletDaoMixin {
  WalletDao(super.attachedDatabase);

  /// Default wallet first, then by name. Archived wallets are included;
  /// callers filter.
  Stream<List<WalletRow>> watchAll() =>
      (select(wallets)..orderBy([
            (t) => OrderingTerm.desc(t.isDefault),
            (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
          ]))
          .watch();

  Stream<WalletRow?> watch(String id) =>
      (select(wallets)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<void> upsertAll(List<WalletRow> rows) => batch(
    (b) => b.insertAllOnConflictUpdate(
      wallets,
      rows.map((row) => row.toCompanion(false)),
    ),
  );

  Future<void> deleteById(String id) =>
      (delete(wallets)..where((t) => t.id.equals(id))).go();

  Future<void> replaceAll(List<WalletRow> rows) => transaction(() async {
    await delete(wallets).go();
    await upsertAll(rows);
  });
}
