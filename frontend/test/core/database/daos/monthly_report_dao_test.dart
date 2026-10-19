import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/monai_database.dart';

import '../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('watch returns the breakdown in position order', () async {
    // Arrange
    await database.monthlyReportDao.replace(monthlyReportRow(), [
      reportCategoryRow(categoryId: 'c2', position: 1),
      reportCategoryRow(categoryId: 'c1', position: 0),
    ]);

    // Act
    final result = await database.monthlyReportDao
        .watch(DateTime(2026, 10))
        .first;

    // Assert
    expect(result?.report, monthlyReportRow());
    expect(result?.categories.map((c) => c.categoryId), ['c1', 'c2']);
  });

  test('watch returns a report without a breakdown', () async {
    // Arrange
    await database.monthlyReportDao.replace(monthlyReportRow(), []);

    // Act
    final result = await database.monthlyReportDao
        .watch(DateTime(2026, 10))
        .first;

    // Assert
    expect(result?.categories, isEmpty);
  });

  test('replace swaps the whole breakdown', () async {
    // Arrange
    await database.monthlyReportDao.replace(monthlyReportRow(), [
      reportCategoryRow(categoryId: 'c1'),
    ]);

    // Act
    await database.monthlyReportDao.replace(monthlyReportRow(), [
      reportCategoryRow(categoryId: 'c2'),
    ]);

    // Assert
    final result = await database.monthlyReportDao
        .watch(DateTime(2026, 10))
        .first;
    expect(result?.categories.map((c) => c.categoryId), ['c2']);
  });

  test('deleteByMonth cascades to the breakdown', () async {
    // Arrange
    await database.monthlyReportDao.replace(monthlyReportRow(), [
      reportCategoryRow(),
    ]);

    // Act
    await database.monthlyReportDao.deleteByMonth(DateTime(2026, 10));

    // Assert
    final categories = await database.select(database.reportCategories).get();
    expect(categories, isEmpty);
  });

  test('watchBetween lists the months in range, oldest first', () async {
    // Arrange
    for (final month in [8, 10, 9, 11]) {
      await database.monthlyReportDao.replace(
        monthlyReportRow(month: DateTime(2026, month)),
        [],
      );
    }

    // Act
    final result = await database.monthlyReportDao
        .watchBetween(DateTime(2026, 9), DateTime(2026, 10))
        .first;

    // Assert
    expect(result.map((r) => r.month), [DateTime(2026, 9), DateTime(2026, 10)]);
  });
}
