import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/datasources/wallet_local_datasource.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;
  late WalletLocalDataSourceImpl dataSource;

  setUp(() {
    database = openTestDatabase();
    dataSource = WalletLocalDataSourceImpl(dao: database.walletDao);
  });

  tearDown(() => database.close());

  test('saving a new default clears the old one', () async {
    // Arrange
    await database.walletDao.upsertAll([
      walletRow(id: 'w1', name: 'Cash', isDefault: true),
      walletRow(id: 'w2', name: 'BCA'),
    ]);

    // Act
    await dataSource.save(walletRow(id: 'w2', name: 'BCA', isDefault: true));

    // Assert
    final wallets = await dataSource.watchAll().first;
    expect(
      {for (final wallet in wallets) wallet.id: wallet.isDefault},
      {'w1': false, 'w2': true},
    );
  });

  test('saving a wallet that is not the default leaves the default', () async {
    // Arrange
    await database.walletDao.upsertAll([
      walletRow(id: 'w1', name: 'Cash', isDefault: true),
    ]);

    // Act
    await dataSource.save(walletRow(id: 'w2', name: 'BCA'));

    // Assert
    final wallets = await dataSource.watchAll().first;
    expect(wallets.firstWhere((wallet) => wallet.id == 'w1').isDefault, isTrue);
    expect(wallets, hasLength(2));
  });

  test('find gives the cached wallet, or null', () async {
    // Arrange
    await database.walletDao.upsertAll([walletRow(id: 'w1')]);

    // Act
    final found = await dataSource.find('w1');
    final missing = await dataSource.find('w2');

    // Assert
    expect(found?.id, 'w1');
    expect(missing, isNull);
  });
}
