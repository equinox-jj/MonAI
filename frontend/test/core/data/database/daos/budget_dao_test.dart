import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/monai_database.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('watches the budget of one month', () async {
    // Arrange
    await database.budgetDao.upsert(budgetRow(month: DateTime(2026, 9)));
    await database.budgetDao.upsert(
      budgetRow(month: DateTime(2026, 10), limitAmount: 2000000),
    );

    // Act
    final result = await database.budgetDao.watch(DateTime(2026, 10)).first;

    // Assert
    expect(result?.limitAmount, 2000000);
  });

  test('deleteByMonth removes the month', () async {
    // Arrange
    await database.budgetDao.upsert(budgetRow());

    // Act
    await database.budgetDao.deleteByMonth(DateTime(2026, 10));

    // Assert
    final result = await database.budgetDao.watch(DateTime(2026, 10)).first;
    expect(result, isNull);
  });
}
