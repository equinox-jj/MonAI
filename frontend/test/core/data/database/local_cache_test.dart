import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/daos/transaction_filter.dart';
import 'package:monai/core/data/database/local_cache.dart';
import 'package:monai/core/data/database/monai_database.dart';

import '../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;
  late DriftLocalCache cache;

  setUp(() {
    database = openTestDatabase();
    cache = DriftLocalCache(database);
  });
  tearDown(() => database.close());

  test('clear empties every table and the search index', () async {
    // Arrange
    await database.walletDao.upsertAll([walletRow()]);
    await database.categoryDao.upsertAll([categoryRow()]);
    await database.transactionDao.upsertAll([transactionRow(note: 'kopi')]);
    await database.budgetDao.upsert(budgetRow());
    await database.paymentProviderDao.upsertAll([paymentProviderRow()]);
    await database.monthlyReportDao.replace(monthlyReportRow(), [
      reportCategoryRow(),
    ]);
    await database.userDao.upsert(userRow());

    // Act
    await cache.clear();

    // Assert
    for (final table in database.allTables) {
      if (table is VirtualTableInfo) continue;
      expect(
        await database.select(table).get(),
        isEmpty,
        reason: table.actualTableName,
      );
    }
    final search = await database.transactionDao
        .watchSearch(
          '"kopi"*',
          TransactionFilter(from: DateTime(2026), to: DateTime(2027)),
          limit: 10,
        )
        .first;
    expect(search, isEmpty);
  });
}
