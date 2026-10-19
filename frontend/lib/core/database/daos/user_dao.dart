import 'package:drift/drift.dart';
import 'package:monai/core/database/monai_database.dart';
import 'package:monai/core/database/tables/users_table.dart';

part 'user_dao.g.dart';

/// Reads and writes the cached signed-in user.
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<MonAIDatabase> with _$UserDaoMixin {
  UserDao(super.attachedDatabase);

  /// The signed-in user, or null before `GET /me` has been cached.
  Stream<UserRow?> watch() => (select(users)..limit(1)).watchSingleOrNull();

  Future<void> upsert(UserRow row) =>
      into(users).insertOnConflictUpdate(row.toCompanion(false));

  Future<void> deleteAll() => delete(users).go();

  /// Keeps the table at one row, even if the id changed.
  Future<void> replace(UserRow row) => transaction(() async {
    await deleteAll();
    await upsert(row);
  });
}
