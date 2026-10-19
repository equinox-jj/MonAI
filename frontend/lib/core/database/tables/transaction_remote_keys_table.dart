import 'package:drift/drift.dart';

/// Where paging left off for one transaction list query. [queryKey] encodes
/// the month, filters and search text; [nextCursor] is null once the last page
/// is loaded.
@DataClassName('TransactionRemoteKeyRow')
class TransactionRemoteKeys extends Table {
  TextColumn get queryKey => text()();
  TextColumn get nextCursor => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {queryKey};
}
