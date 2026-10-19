import 'package:drift/drift.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/database/tables/payment_provider_catalog_table.dart';
import 'package:monai/core/database/tables/payment_providers_table.dart';

part 'payment_provider_dao.g.dart';

/// Reads and writes the cached payment provider catalog.
@DriftAccessor(tables: [PaymentProviders, PaymentProviderCatalog])
class PaymentProviderDao extends DatabaseAccessor<MonAIDatabase>
    with _$PaymentProviderDaoMixin {
  PaymentProviderDao(super.attachedDatabase);

  /// The id of the catalog's single version/ETag row.
  static const catalogRowId = 0;

  /// Every provider, in the server's sort order, then by name.
  Stream<List<PaymentProviderRow>> watchAll() =>
      (select(paymentProviders)..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
          ]))
          .watch();

  /// The catalog's version and ETag, or null until it has been cached once.
  Future<PaymentProviderCatalogRow?> catalogMeta() => (select(
    paymentProviderCatalog,
  )..where((t) => t.id.equals(catalogRowId))).getSingleOrNull();

  Future<void> upsertMeta(PaymentProviderCatalogRow meta) =>
      into(paymentProviderCatalog)
          .insertOnConflictUpdate(meta.toCompanion(false));

  Future<void> upsertAll(List<PaymentProviderRow> rows) => batch(
    (b) => b.insertAllOnConflictUpdate(
      paymentProviders,
      rows.map((row) => row.toCompanion(false)),
    ),
  );

  Future<void> deleteAll() => delete(paymentProviders).go();

  /// Stores a new catalog and its version/ETag together, so they never
  /// disagree.
  Future<void> replaceCatalog(
    PaymentProviderCatalogRow meta,
    List<PaymentProviderRow> rows,
  ) => transaction(() async {
    await deleteAll();
    await upsertAll(rows);
    await upsertMeta(meta);
  });
}
