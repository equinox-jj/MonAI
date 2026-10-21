import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_local_datasource.dart';

import '../../../../helpers/database_fixtures.dart';

void main() {
  late MonAIDatabase database;
  late PaymentProviderLocalDataSourceImpl dataSource;

  setUp(() {
    database = openTestDatabase();
    dataSource = PaymentProviderLocalDataSourceImpl(
      dao: database.paymentProviderDao,
    );
  });

  tearDown(() => database.close());

  test('has no ETag before a catalog is cached', () async {
    // Arrange
    // (empty database from setUp)

    // Act
    final etag = await dataSource.etag();

    // Assert
    expect(etag, isNull);
  });

  test('gives the ETag of the cached catalog', () async {
    // Arrange
    await dataSource.replaceCatalog(
      version: 3,
      etag: '"v3"',
      rows: [paymentProviderRow()],
    );

    // Act
    final etag = await dataSource.etag();

    // Assert
    expect(etag, '"v3"');
    expect(await dataSource.watchAll().first, hasLength(1));
  });

  test('ignores the ETag of an empty catalog, so it is downloaded', () async {
    // Arrange
    await dataSource.replaceCatalog(version: 3, etag: '"v3"', rows: const []);

    // Act
    final etag = await dataSource.etag();

    // Assert
    expect(etag, isNull);
  });
}
