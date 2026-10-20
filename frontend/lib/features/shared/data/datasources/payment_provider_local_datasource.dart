import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/payment_provider_dao.dart';
import 'package:monai/core/database/monai_database.dart';

abstract class PaymentProviderLocalDataSource {
  /// The cached catalog in its sort order.
  Stream<List<PaymentProviderRow>> watchAll();

  /// The ETag to revalidate the cached catalog with; null when nothing is
  /// cached, so the next fetch downloads it whole.
  Future<String?> etag();

  /// Replaces the catalog and remembers its version and [etag].
  Future<void> replaceCatalog({
    required int version,
    required String? etag,
    required List<PaymentProviderRow> rows,
  });

  /// Stores the bundled seed [rows] when nothing is cached yet. It has no
  /// ETag, so the next fetch downloads the whole catalog over it.
  Future<void> seedIfEmpty(List<PaymentProviderRow> rows);
}

class PaymentProviderLocalDataSourceImpl extends PaymentProviderLocalDataSource
    with BaseLocalDataSource {
  PaymentProviderLocalDataSourceImpl({required this._dao});

  final PaymentProviderDao _dao;

  @override
  Stream<List<PaymentProviderRow>> watchAll() => safeCacheStream(_dao.watchAll);

  @override
  Future<String?> etag() => safeCacheCall(() async {
    final providers = await _dao.watchAll().first;
    if (providers.isEmpty) return null;
    return (await _dao.catalogMeta())?.etag;
  });

  @override
  Future<void> replaceCatalog({
    required int version,
    required String? etag,
    required List<PaymentProviderRow> rows,
  }) => safeCacheCall(
    () => _dao.replaceCatalog(
      PaymentProviderCatalogRow(
        id: PaymentProviderDao.catalogRowId,
        version: version,
        etag: etag,
      ),
      rows,
    ),
  );

  @override
  Future<void> seedIfEmpty(List<PaymentProviderRow> rows) => safeCacheCall(
    () => _dao.seedIfEmpty(
      const PaymentProviderCatalogRow(
        id: PaymentProviderDao.catalogRowId,
        version: 0,
      ),
      rows,
    ),
  );
}
