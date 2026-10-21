import 'package:drift/drift.dart';

/// The cached payment provider catalog's version and ETag; a single row whose
/// [id] is `PaymentProviderDao.catalogRowId`.
@DataClassName('PaymentProviderCatalogRow')
class PaymentProviderCatalog extends Table {
  IntColumn get id => integer()();
  IntColumn get version => integer()();
  TextColumn get etag => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
