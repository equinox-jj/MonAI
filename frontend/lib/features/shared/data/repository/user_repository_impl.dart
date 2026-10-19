import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/data/datasources/user_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_remote_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/user_mapper.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository with BaseRepository {
  UserRepositoryImpl({required this._remote, required this._local});

  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;

  @override
  Stream<Either<Failure, User?>> watchUser() =>
      safeStream(() => _local.watch().map((row) => row?.toEntity()));

  @override
  Future<Either<Failure, User>> refreshUser() => safeCall(() async {
    final response = await _remote.getMe();
    final row = requireField(response.data).toRow();
    await _local.replace(row);
    return row.toEntity();
  });
}
