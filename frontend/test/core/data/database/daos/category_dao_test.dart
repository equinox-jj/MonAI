import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/model/category_type.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('lists categories of one type by name ignoring case', () async {
    // Arrange
    await database.categoryDao.upsertAll([
      categoryRow(id: 'c1', name: 'transport'),
      categoryRow(id: 'c2', name: 'Food'),
      categoryRow(id: 'c3', name: 'Salary', type: CategoryType.income),
    ]);

    // Act
    final result = await database.categoryDao
        .watchByType(CategoryType.expense)
        .first;

    // Assert
    expect(result.map((c) => c.id), ['c2', 'c1']);
  });

  test('replaceAll drops categories the server no longer returns', () async {
    // Arrange
    await database.categoryDao.upsertAll([
      categoryRow(id: 'c1'),
      categoryRow(id: 'c2'),
    ]);

    // Act
    await database.categoryDao.replaceAll([categoryRow(id: 'c1')]);

    // Assert
    final result = await database.categoryDao.watchAll().first;
    expect(result.map((c) => c.id), ['c1']);
  });
}
