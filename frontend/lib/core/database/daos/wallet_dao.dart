import 'package:drift/drift.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/database/tables/wallets_table.dart';

part 'wallet_dao.g.dart';

/// Reads and writes the cached wallets.
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

  /// The wallet with [id], or null when it isn't cached.
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

  /// Swaps in a full list from the server, dropping wallets it no longer
  /// returns.
  Future<void> replaceAll(List<WalletRow> rows) => transaction(() async {
    await delete(wallets).go();
    await upsertAll(rows);
  });
}
