import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/daos/payment_provider_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;

  setUp(() => database = openTestDatabase());
  tearDown(() => database.close());

  test('catalogMeta is null until the catalog is cached', () async {
    // Arrange
    final dao = database.paymentProviderDao;

    // Act
    final result = await dao.catalogMeta();

    // Assert
    expect(result, isNull);
  });

  test('lists providers by sort order, then by name', () async {
    // Arrange
    await database.paymentProviderDao.upsertAll([
      paymentProviderRow(id: 'p1', name: 'OVO', sortOrder: 1),
      paymentProviderRow(id: 'p2', name: 'dana', sortOrder: 1),
      paymentProviderRow(id: 'p3', name: 'Mandiri'),
    ]);

    // Act
    final result = await database.paymentProviderDao.watchAll().first;

    // Assert
    expect(result.map((p) => p.id), ['p3', 'p2', 'p1']);
  });

  test('replaceCatalog swaps providers and meta together', () async {
    // Arrange
    const oldMeta = PaymentProviderCatalogRow(
      id: PaymentProviderDao.catalogRowId,
      version: 1,
      etag: 'v1',
    );
    const newMeta = PaymentProviderCatalogRow(
      id: PaymentProviderDao.catalogRowId,
      version: 2,
      etag: 'v2',
    );
    await database.paymentProviderDao.replaceCatalog(oldMeta, [
      paymentProviderRow(id: 'p1'),
    ]);

    // Act
    await database.paymentProviderDao.replaceCatalog(newMeta, [
      paymentProviderRow(id: 'p2'),
    ]);

    // Assert
    final providers = await database.paymentProviderDao.watchAll().first;
    expect(providers.map((p) => p.id), ['p2']);
    expect(await database.paymentProviderDao.catalogMeta(), newMeta);
  });

  test('seedIfEmpty stores the seed and its meta in an empty cache', () async {
    // Arrange
    final dao = database.paymentProviderDao;
    const meta = PaymentProviderCatalogRow(
      id: PaymentProviderDao.catalogRowId,
      version: 0,
    );

    // Act
    final stored = await dao.seedIfEmpty(meta, [
      paymentProviderRow(id: 'seed:bca'),
    ]);

    // Assert
    expect(stored, isTrue);
    expect((await dao.watchAll().first).map((p) => p.id), ['seed:bca']);
    expect(await dao.catalogMeta(), meta);
  });

  test('seedIfEmpty keeps a catalog already cached', () async {
    // Arrange
    final dao = database.paymentProviderDao;
    await dao.upsertAll([paymentProviderRow(id: 'p1')]);

    // Act
    final stored = await dao.seedIfEmpty(
      const PaymentProviderCatalogRow(
        id: PaymentProviderDao.catalogRowId,
        version: 0,
      ),
      [paymentProviderRow(id: 'seed:bca')],
    );

    // Assert
    expect(stored, isFalse);
    expect((await dao.watchAll().first).map((p) => p.id), ['p1']);
  });
}
