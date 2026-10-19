import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/daos/transaction_filter.dart';
import 'package:monai/core/database/fts_query.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/transaction_type.dart';

import '../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  final october = TransactionFilter(
    from: DateTime(2026, 10),
    to: DateTime(2026, 10, 31),
  );

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  Future<List<String>> pageIds(TransactionFilter filter, {int limit = 50}) =>
      database.transactionDao
          .watchPage(filter, limit: limit)
          .first
          .then((rows) => rows.map((t) => t.id).toList());

  Future<List<String>> searchIds(String text) => database.transactionDao
      .watchSearch(toFtsMatchQuery(text)!, october, limit: 50)
      .first
      .then((rows) => rows.map((t) => t.id).toList());

  group('watchPage', () {
    test('orders by date then id, newest first, up to the limit', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', date: DateTime(2026, 10, 2)),
        transactionRow(id: 'b', date: DateTime(2026, 10, 3)),
        transactionRow(id: 'c', date: DateTime(2026, 10, 2)),
        transactionRow(id: 'd', date: DateTime(2026, 9, 30)),
      ]);

      // Act
      final result = await pageIds(october, limit: 2);

      // Assert
      expect(result, ['b', 'c']);
    });

    test('a wallet filter matches the destination of a transfer', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', walletId: 'w1'),
        transactionRow(
          id: 'b',
          type: TransactionType.transfer,
          walletId: 'w2',
          toWalletId: 'w1',
          categoryId: null,
        ),
        transactionRow(id: 'c', walletId: 'w2'),
      ]);
      final filter = TransactionFilter(
        from: october.from,
        to: october.to,
        walletId: 'w1',
      );

      // Act
      final result = await pageIds(filter);

      // Assert
      expect(result, unorderedEquals(['a', 'b']));
    });

    test('filters by category and type', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', categoryId: 'c1'),
        transactionRow(id: 'b', categoryId: 'c2'),
        transactionRow(id: 'c', categoryId: 'c1', type: TransactionType.income),
      ]);
      final filter = TransactionFilter(
        from: october.from,
        to: october.to,
        categoryId: 'c1',
        type: TransactionType.expense,
      );

      // Act
      final result = await pageIds(filter);

      // Assert
      expect(result, ['a']);
    });
  });

  test('upsert clears a nullable column', () async {
    // Arrange
    await database.transactionDao.upsertAll([transactionRow(note: 'kopi')]);

    // Act
    await database.transactionDao.upsertAll([transactionRow()]);

    // Assert
    final result = await database.transactionDao.watch('t1').first;
    expect(result?.note, isNull);
    expect(await searchIds('kopi'), isEmpty);
  });

  group('watchSearch', () {
    test('prefix-matches note or merchant ignoring case', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', merchant: 'Kopi Kenangan'),
        transactionRow(id: 'b', note: 'kopi susu'),
        transactionRow(id: 'c', note: 'Makan siang'),
      ]);

      // Act
      final result = await searchIds('KOPI');

      // Assert
      expect(result, unorderedEquals(['a', 'b']));
    });

    test('follows updates and deletes', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', note: 'kopi'),
        transactionRow(id: 'b', note: 'kopi'),
      ]);

      // Act
      await database.transactionDao.upsertAll([
        transactionRow(id: 'a', note: 'teh'),
      ]);
      await database.transactionDao.deleteById('b');

      // Assert
      expect(await searchIds('kopi'), isEmpty);
      expect(await searchIds('teh'), ['a']);
    });
  });

  test(
    'watchDailyNets sums income minus expense, ignoring transfers',
    () async {
      // Arrange
      final day = DateTime(2026, 10, 5);
      await database.transactionDao.upsertAll([
        transactionRow(
          id: 'a',
          type: TransactionType.income,
          amount: 50000,
          date: day,
        ),
        transactionRow(id: 'b', amount: 20000, date: day),
        transactionRow(
          id: 'c',
          type: TransactionType.transfer,
          amount: 99000,
          toWalletId: 'w2',
          date: day,
        ),
      ]);

      // Act
      final result = await database.transactionDao
          .watchDailyNets(october)
          .first;

      // Assert
      expect(result, [(date: day, net: 30000)]);
    },
  );

  test('watchDailyOutflows counts expenses and transfers out only', () async {
    // Arrange
    final day = DateTime(2026, 10, 5);
    await database.transactionDao.upsertAll([
      transactionRow(id: 'a', amount: 20000, date: day),
      transactionRow(
        id: 'b',
        type: TransactionType.transfer,
        amount: 5000,
        toWalletId: 'w2',
        date: day,
      ),
      transactionRow(
        id: 'c',
        type: TransactionType.transfer,
        amount: 7000,
        walletId: 'w2',
        toWalletId: 'w1',
        date: day,
      ),
      transactionRow(
        id: 'd',
        type: TransactionType.income,
        amount: 1000,
        date: day,
      ),
    ]);

    // Act
    final result = await database.transactionDao
        .watchDailyOutflows(october.from, october.to, 'w1')
        .first;

    // Assert
    expect(result, [(date: day, amount: 25000)]);
  });

  test('watchRecent returns the newest rows in range', () async {
    // Arrange
    await database.transactionDao.upsertAll([
      transactionRow(id: 'a', date: DateTime(2026, 10, 1)),
      transactionRow(id: 'b', date: DateTime(2026, 10, 2)),
      transactionRow(id: 'c', date: DateTime(2026, 11, 1)),
    ]);

    // Act
    final result = await database.transactionDao
        .watchRecent(october.from, october.to, limit: 1)
        .first;

    // Assert
    expect(result.map((t) => t.id), ['b']);
  });

  group('latestCategoryForText', () {
    test('returns the category of the latest edited match', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(
          id: 'a',
          note: ' Kopi ',
          categoryId: 'old',
          updatedAt: DateTime.utc(2026, 10, 1),
        ),
        transactionRow(
          id: 'b',
          merchant: 'KOPI',
          categoryId: 'new',
          updatedAt: DateTime.utc(2026, 10, 2),
        ),
        transactionRow(
          id: 'c',
          note: 'kopi',
          categoryId: 'income',
          type: TransactionType.income,
          updatedAt: DateTime.utc(2026, 10, 3),
        ),
      ]);

      // Act
      final result = await database.transactionDao.latestCategoryForText(
        'kopi',
        TransactionType.expense,
      );

      // Assert
      expect(result, 'new');
    });

    test('returns null when nothing matches', () async {
      // Arrange
      await database.transactionDao.upsertAll([transactionRow(note: 'teh')]);

      // Act
      final result = await database.transactionDao.latestCategoryForText(
        'kopi',
        TransactionType.expense,
      );

      // Assert
      expect(result, isNull);
    });
  });

  test('moveCategory moves every transaction of a category', () async {
    // Arrange
    await database.transactionDao.upsertAll([
      transactionRow(id: 'a', categoryId: 'c1'),
      transactionRow(id: 'b', categoryId: 'c2'),
    ]);

    // Act
    await database.transactionDao.moveCategory('c1', 'c3');

    // Assert
    final result = await database.transactionDao.between(
      october.from,
      october.to,
    );
    expect(
      {for (final t in result) t.id: t.categoryId},
      {'a': 'c3', 'b': 'c2'},
    );
  });

  group('replaceRecent', () {
    test('replaces the whole range when there are no more pages', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'old', date: DateTime(2026, 10, 1)),
        transactionRow(id: 'outside', date: DateTime(2026, 9, 30)),
      ]);

      // Act
      await database.transactionDao.replaceRecent(october.from, october.to, [
        transactionRow(id: 'new', date: DateTime(2026, 10, 3)),
      ], hasMore: false);

      // Assert
      final result = await pageIds(
        TransactionFilter(from: DateTime(2026, 9), to: october.to),
      );
      expect(result, ['new', 'outside']);
    });

    test('keeps rows older than the page when there are more', () async {
      // Arrange
      await database.transactionDao.upsertAll([
        transactionRow(id: 'gone', date: DateTime(2026, 10, 9)),
        transactionRow(id: 'b', date: DateTime(2026, 10, 5)),
        transactionRow(id: 'kept', date: DateTime(2026, 10, 2)),
      ]);

      // Act
      await database.transactionDao.replaceRecent(october.from, october.to, [
        transactionRow(id: 'x', date: DateTime(2026, 10, 8)),
        transactionRow(id: 'c', date: DateTime(2026, 10, 5)),
      ], hasMore: true);

      // Assert
      expect(await pageIds(october), ['x', 'c', 'b', 'kept']);
    });
  });

  test('replaceQueryPage swaps only the rows the filter shows', () async {
    // Arrange
    await database.transactionDao.upsertAll([
      transactionRow(id: 'w1-old', walletId: 'w1'),
      transactionRow(id: 'w2', walletId: 'w2'),
    ]);
    final filter = TransactionFilter(
      from: october.from,
      to: october.to,
      walletId: 'w1',
    );
    final key = TransactionRemoteKeyRow(
      queryKey: 'w1-oct',
      nextCursor: 'cursor-2',
      updatedAt: DateTime.utc(2026, 10, 19),
    );

    // Act
    await database.transactionDao.replaceQueryPage(filter, [
      transactionRow(id: 'w1-new', walletId: 'w1'),
    ], key);

    // Assert
    expect(await pageIds(october), unorderedEquals(['w1-new', 'w2']));
    expect(await database.transactionDao.remoteKey('w1-oct'), key);
  });

  test('appendQueryPage adds rows and moves the cursor on', () async {
    // Arrange
    await database.transactionDao.upsertRemoteKey(
      TransactionRemoteKeyRow(
        queryKey: 'oct',
        nextCursor: 'cursor-2',
        updatedAt: DateTime.utc(2026, 10, 19),
      ),
    );
    final last = TransactionRemoteKeyRow(
      queryKey: 'oct',
      updatedAt: DateTime.utc(2026, 10, 19, 1),
    );

    // Act
    await database.transactionDao.appendQueryPage([transactionRow()], last);

    // Assert
    expect(await pageIds(october), ['t1']);
    expect(await database.transactionDao.remoteKey('oct'), last);
  });
}
