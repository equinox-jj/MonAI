import 'package:drift/drift.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/database/tables/payment_provider_catalog_table.dart';
import 'package:monai/core/data/database/tables/payment_providers_table.dart';

part 'payment_provider_dao.g.dart';

@DriftAccessor(tables: [PaymentProviders, PaymentProviderCatalog])
class PaymentProviderDao extends DatabaseAccessor<MonAIDatabase>
    with _$PaymentProviderDaoMixin {
  PaymentProviderDao(super.attachedDatabase);

  static const catalogRowId = 0;

  Stream<List<PaymentProviderRow>> watchAll() =>
      (select(paymentProviders)..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
          ]))
          .watch();

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

  /// In one transaction, so the catalog and its version/ETag never disagree.
  Future<void> replaceCatalog(
    PaymentProviderCatalogRow meta,
    List<PaymentProviderRow> rows,
  ) => transaction(() async {
    await deleteAll();
    await upsertAll(rows);
    await upsertMeta(meta);
  });

  /// Only while none is cached, so a catalog fetched meanwhile is never
  /// overwritten. True when it stored [rows].
  Future<bool> seedIfEmpty(
    PaymentProviderCatalogRow meta,
    List<PaymentProviderRow> rows,
  ) => transaction(() async {
    final cached = await (selectOnly(
      paymentProviders,
    )..addColumns([paymentProviders.id.count()])).getSingle();
    if ((cached.read(paymentProviders.id.count()) ?? 0) > 0) return false;
    await upsertAll(rows);
    await upsertMeta(meta);
    return true;
  });
}
