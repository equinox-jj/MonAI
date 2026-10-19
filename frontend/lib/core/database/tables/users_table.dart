import 'package:drift/drift.dart';
import 'package:monai/core/database/converters.dart';

/// The signed-in user; the table holds at most one row.
@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();

  /// Presigned and short-lived, so a cached one may have expired; the UI
  /// falls back to initials.
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get timezone => text()();
  TextColumn get roleSlug => text()();
  TextColumn get roleName => text()();

  /// Sorted, so the stored value doesn't depend on the order received.
  TextColumn get permissions => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
