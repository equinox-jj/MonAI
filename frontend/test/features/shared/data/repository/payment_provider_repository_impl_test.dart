import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/payment_provider_mapper.dart';
import 'package:monai/features/shared/data/model/payment_provider_catalog_response.dart';
import 'package:monai/features/shared/data/repository/payment_provider_repository_impl.dart';

import '../../../../helpers/api_fixtures.dart';
import '../../../../helpers/database_fixtures.dart';

class _MockRemote extends Mock implements PaymentProviderRemoteDataSource {}

class _MockLocal extends Mock implements PaymentProviderLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late PaymentProviderRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = PaymentProviderRepositoryImpl(remote: remote, local: local);
    when(() => local.etag()).thenAnswer((_) async => '"v2"');
    when(
      () => local.replaceCatalog(
        version: any(named: 'version'),
        etag: any(named: 'etag'),
        rows: any(named: 'rows'),
      ),
    ).thenAnswer((_) async {});
  });

  test('stores a changed catalog with its version and ETag', () async {
    // Arrange
    when(() => remote.getCatalog(etag: any(named: 'etag'))).thenAnswer(
      (_) async => (
        body: PaymentProviderCatalogResponse.fromJson(
          envelope({
            'version': 3,
            'providers': [providerJson()],
          }),
        ),
        etag: '"v3"',
      ),
    );

    // Act
    final result = await repository.refreshProviders();

    // Assert
    verify(() => remote.getCatalog(etag: '"v2"')).called(1);
    final rows =
        verify(
              () => local.replaceCatalog(
                version: 3,
                etag: '"v3"',
                rows: captureAny(named: 'rows'),
              ),
            ).captured.single
            as List<PaymentProviderRow>;
    expect(rows.single.name, 'BCA');
    expect(result.getRight().toNullable(), [rows.single.toEntity()]);
  });

  test(
    'a 304 leaves the cache as it is and gives the cached catalog',
    () async {
      // Arrange
      final cached = paymentProviderRow();
      when(() => remote.getCatalog(etag: any(named: 'etag')))
          .thenAnswer((_) async => null);
      when(() => local.watchAll()).thenAnswer((_) => Stream.value([cached]));

      // Act
      final result = await repository.refreshProviders();

      // Assert
      expect(result.getRight().toNullable(), [cached.toEntity()]);
      verifyNever(
        () => local.replaceCatalog(
          version: any(named: 'version'),
          etag: any(named: 'etag'),
          rows: any(named: 'rows'),
        ),
      );
    },
  );

  test('watchProviders maps the cached rows', () async {
    // Arrange
    when(() => local.watchAll())
        .thenAnswer((_) => Stream.value([paymentProviderRow()]));

    // Act
    final result = await repository.watchProviders().first;

    // Assert
    expect(result.getRight().toNullable()?.single.aliases, [
      'bank central asia',
    ]);
  });
}
