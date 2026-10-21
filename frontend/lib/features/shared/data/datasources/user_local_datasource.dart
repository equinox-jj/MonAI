import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/user_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';

abstract class UserLocalDataSource {
  Stream<UserRow?> watch();

  Future<void> replace(UserRow row);
}

class UserLocalDataSourceImpl extends UserLocalDataSource
    with BaseLocalDataSource {
  UserLocalDataSourceImpl({required this._dao});

  final UserDao _dao;

  @override
  Stream<UserRow?> watch() => safeCacheStream(_dao.watch);

  @override
  Future<void> replace(UserRow row) => safeCacheCall(() => _dao.replace(row));
}
