import 'package:drift/drift.dart';
import 'package:monai/core/data/database/monai_database.dart';

/// Cleared on logout and when the session expires, so the next user never
/// sees it.
abstract interface class LocalCache {
  Future<void> clear();
}

class DriftLocalCache implements LocalCache {
  const DriftLocalCache(this._database);

  final MonAIDatabase _database;

  @override
  Future<void> clear() => _database.transaction(() async {
    // Virtual tables are skipped: the FTS index empties through the
    // transactions triggers.
    final tables = _database.allTables.where(
      (table) => table is! VirtualTableInfo,
    );
    for (final table in tables) {
      await _database.delete(table).go();
    }
  });
}
