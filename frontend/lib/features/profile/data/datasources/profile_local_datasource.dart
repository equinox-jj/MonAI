import 'package:monai/core/data/base_local_data_source.dart';
import 'package:monai/core/database/daos/user_dao.dart';
import 'package:monai/core/database/monai_database.dart';

abstract class ProfileLocalDataSource {
  /// Caches [row] as the signed-in user.
  Future<void> saveUser(UserRow row);

  /// Drops the cached user's profile photo.
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
