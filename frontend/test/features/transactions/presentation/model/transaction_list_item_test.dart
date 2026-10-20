import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/transactions/presentation/model/transaction_list_item.dart';

import '../../../../helpers/entity_fixtures.dart';

void main() {
  final today = DateTime(2026, 10, 10);
  final yesterday = DateTime(2026, 10, 9);

  test('puts a header with its net before each day', () {
    // Arrange
    final transactions = [
      transaction(id: 'a', date: today),
      transaction(id: 'b', date: today),
      transaction(id: 'c', date: yesterday),
    ];

    // Act
    final items = groupByDay(
      transactions,
      dailyNets: {today: -65000, yesterday: -28000},
    );

    // Assert
    expect(items.map(_describe), [
      'day 2026-10-10 -65000',
      'a',
      'b last',
      'day 2026-10-09 -28000',
      'c last',
    ]);
  });

  test('leaves the net out without daily nets', () {
    // Arrange
    final transactions = [transaction(id: 'a', date: today)];

    // Act
    final items = groupByDay(transactions);

    // Assert
    expect(items.map(_describe), ['day 2026-10-10 null', 'a last']);
  });

  test('gives nothing for no transactions', () {
    // Arrange
    // (no transactions)

    // Act
    final items = groupByDay(const []);

    // Assert
    expect(items, isEmpty);
  });
}

String _describe(TransactionListItem item) => switch (item) {
  TransactionDayItem(:final date, :final net) =>
    'day ${date.toIso8601String().substring(0, 10)} $net',
  TransactionEntryItem(:final transaction, :final isLastOfDay) =>
    isLastOfDay ? '${transaction.id} last' : transaction.id,
};
