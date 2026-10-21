import 'package:drift/drift.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/database/tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<MonAIDatabase> with _$UserDaoMixin {
  UserDao(super.attachedDatabase);

  Stream<UserRow?> watch() => (select(users)..limit(1)).watchSingleOrNull();

  Future<void> upsert(UserRow row) =>
      into(users).insertOnConflictUpdate(row.toCompanion(false));

  Future<void> deleteAll() => delete(users).go();

  /// Keeps the table at one row, even if the id changed.
  Future<void> replace(UserRow row) => transaction(() async {
    await deleteAll();
    await upsert(row);
  });

  Future<void> clearAvatar() =>
      update(users).write(const UsersCompanion(avatarUrl: Value(null)));
}
