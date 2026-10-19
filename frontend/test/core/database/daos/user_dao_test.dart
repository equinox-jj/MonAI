import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/monai_database.dart';

import '../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('watch is null before a user is cached', () async {
    // Arrange
    final dao = database.userDao;

    // Act
    final result = await dao.watch().first;

    // Assert
    expect(result, isNull);
  });

  test('replace keeps a single row when the id changes', () async {
    // Arrange
    await database.userDao.upsert(userRow(id: 'u1'));

    // Act
    await database.userDao.replace(userRow(id: 'u2'));

    // Assert
    final rows = await database.select(database.users).get();
    expect(rows.map((u) => u.id), ['u2']);
    expect(rows.single.permissions, ['transactions.read']);
  });
}
