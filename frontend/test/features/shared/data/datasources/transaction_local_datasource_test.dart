import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/data/datasources/transaction_local_datasource.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;
  late TransactionLocalDataSourceImpl dataSource;
  final now = DateTime.utc(2026, 10, 15, 9);
  final october = DateTime(2026, 10);

  setUp(() {
    database = openTestDatabase();
    dataSource = TransactionLocalDataSourceImpl(
      dao: database.transactionDao,
      now: () => now,
    );
  });

  tearDown(() => database.close());

  group('queryKey', () {
    test('has empty parts for unset filters', () {
      // Arrange
      const filter = TransactionFilter();

      // Act
      final key = TransactionLocalDataSourceImpl.queryKey(october, filter);

      // Assert
      expect(key, '2026-10|||');
    });

    test('encodes every filter', () {
      // Arrange
      const filter = TransactionFilter(
        walletId: 'w1',
        categoryId: 'c1',
        type: TransactionType.expense,
      );

      // Act
      final key = TransactionLocalDataSourceImpl.queryKey(october, filter);

      // Assert
      expect(key, '2026-10|w1|c1|expense');
    });
  });

  test('a list covers its whole month and nothing else', () async {
    // Arrange
    await dataSource.upsertAll([
      transactionRow(id: 'sep', date: DateTime(2026, 9, 30)),
      transactionRow(id: 'first', date: DateTime(2026, 10)),
      transactionRow(id: 'last', date: DateTime(2026, 10, 31)),
      transactionRow(id: 'nov', date: DateTime(2026, 11)),
    ]);

    // Act
    final rows = await dataSource
        .watchPage(october, const TransactionFilter(), limit: 10)
        .first;

    // Assert
    expect(rows.map((row) => row.id), ['last', 'first']);
  });

  test('the filter narrows a list, matching either wallet', () async {
    // Arrange
    await dataSource.upsertAll([
      transactionRow(id: 'out', date: DateTime(2026, 10, 2)),
      transactionRow(
        id: 'in',
        type: TransactionType.transfer,
        walletId: 'w2',
        toWalletId: 'w1',
        categoryId: null,
        date: DateTime(2026, 10, 3),
      ),
      transactionRow(id: 'other', walletId: 'w3', date: DateTime(2026, 10, 4)),
    ]);

    // Act
    final rows = await dataSource
        .watchPage(october, const TransactionFilter(walletId: 'w1'), limit: 10)
        .first;

    // Assert
    expect(rows.map((row) => row.id), ['in', 'out']);
  });

  test('the first page replaces the list and saves its cursor', () async {
    // Arrange
    const filter = TransactionFilter(walletId: 'w1');
    await dataSource.upsertAll([
      transactionRow(id: 'stale', date: DateTime(2026, 10, 5)),
    ]);

    // Act
    await dataSource.replaceFirstPage(october, filter, [
      transactionRow(id: 'fresh', date: DateTime(2026, 10, 6)),
    ], nextCursor: 'abc');

    // Assert
    final rows = await dataSource.watchPage(october, filter, limit: 10).first;
    expect(rows.map((row) => row.id), ['fresh']);
    final key = await dataSource.remoteKey(october, filter);
    expect(key?.queryKey, '2026-10|w1||');
    expect(key?.nextCursor, 'abc');
    expect(key?.updatedAt, now);
  });

  test('a next page is added and moves the cursor on', () async {
    // Arrange
    const filter = TransactionFilter();
    await dataSource.replaceFirstPage(october, filter, [
      transactionRow(id: 'a', date: DateTime(2026, 10, 6)),
    ], nextCursor: 'abc');

    // Act
    await dataSource.appendPage(october, filter, [
      transactionRow(id: 'b', date: DateTime(2026, 10, 2)),
    ], nextCursor: null);

    // Assert
    final rows = await dataSource.watchPage(october, filter, limit: 10).first;
    expect(rows.map((row) => row.id), ['a', 'b']);
    expect((await dataSource.remoteKey(october, filter))?.nextCursor, isNull);
  });

  test('daily nets subtract expenses from income per day', () async {
    // Arrange
    await dataSource.upsertAll([
      transactionRow(id: 'e', amount: 3000, date: DateTime(2026, 10, 2)),
      transactionRow(
        id: 'i',
        type: TransactionType.income,
        amount: 10000,
        date: DateTime(2026, 10, 2),
      ),
    ]);

    // Act
    final nets = await dataSource
        .watchDailyNets(october, const TransactionFilter())
        .first;

    // Assert
    expect(nets, {DateTime(2026, 10, 2): 7000});
  });

  test('search finds any cached month and nothing for blank text', () async {
    // Arrange
    await dataSource.upsertAll([
      transactionRow(id: 'old', note: 'Kopi Kenangan', date: DateTime(2025)),
      transactionRow(id: 'other', note: 'Bensin'),
    ]);

    // Act
    final found = await dataSource
        .watchSearch('kopi ken', const TransactionFilter(), limit: 10)
        .first;
    final blank = await dataSource
        .watchSearch('  !! ', const TransactionFilter(), limit: 10)
        .first;

    // Assert
    expect(found.map((row) => row.id), ['old']);
    expect(blank, isEmpty);
  });

  test('find gives the cached row or null', () async {
    // Arrange
    await dataSource.upsertAll([transactionRow(id: 't1')]);

    // Act
    final cached = await dataSource.find('t1');
    final missing = await dataSource.find('nope');

    // Assert
    expect(cached?.id, 't1');
    expect(missing, isNull);
  });
}
