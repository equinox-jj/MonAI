import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/monai_database.dart';

import '../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('lists the default wallet first, then by name ignoring case', () async {
    // Arrange
    await database.walletDao.upsertAll([
      walletRow(id: 'w1', name: 'dana'),
      walletRow(id: 'w2', name: 'Zed', isDefault: true),
      walletRow(id: 'w3', name: 'BCA'),
    ]);

    // Act
    final result = await database.walletDao.watchAll().first;

    // Assert
    expect(result.map((w) => w.id), ['w2', 'w3', 'w1']);
  });

  test('upsert updates an existing wallet', () async {
    // Arrange
    await database.walletDao.upsertAll([walletRow(name: 'Cash')]);

    // Act
    await database.walletDao.upsertAll([walletRow(name: 'Dompet')]);

    // Assert
    final result = await database.walletDao.watch('w1').first;
    expect(result?.name, 'Dompet');
  });

  test('replaceAll drops wallets the server no longer returns', () async {
    // Arrange
    await database.walletDao.upsertAll([
      walletRow(id: 'w1'),
      walletRow(id: 'w2'),
    ]);

    // Act
    await database.walletDao.replaceAll([walletRow(id: 'w2')]);

    // Assert
    final result = await database.walletDao.watchAll().first;
    expect(result.map((w) => w.id), ['w2']);
  });

  test('deleteById removes one wallet', () async {
    // Arrange
    await database.walletDao.upsertAll([walletRow()]);

    // Act
    await database.walletDao.deleteById('w1');

    // Assert
    final result = await database.walletDao.watch('w1').first;
    expect(result, isNull);
  });
}
