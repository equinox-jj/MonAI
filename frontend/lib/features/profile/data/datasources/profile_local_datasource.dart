import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/daos/user_dao.dart';
import 'package:monai/core/data/database/monai_database.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveUser(UserRow row);

  Future<void> clearAvatar();
}

class ProfileLocalDataSourceImpl extends ProfileLocalDataSource
    with BaseLocalDataSource {
  ProfileLocalDataSourceImpl({required this._dao});

  final UserDao _dao;

  @override
  Future<void> saveUser(UserRow row) => safeCacheCall(() => _dao.replace(row));

  @override
  Future<void> clearAvatar() => safeCacheCall(_dao.clearAvatar);
}
