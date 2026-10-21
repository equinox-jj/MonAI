import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/services/image_compressor_service.dart';
import 'package:monai/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:monai/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:monai/features/profile/data/model/delete_account_request.dart';
import 'package:monai/features/profile/data/model/update_profile_request.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/mapper/user_mapper.dart';
import 'package:monai/features/shared/data/model/me_response.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

class ProfileRepositoryImpl extends ProfileRepository with BaseRepository {
  ProfileRepositoryImpl({
    required this._remote,
    required this._local,
    required this._compressor,
  });

  static const _avatarFilename = 'avatar.webp';

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;
  final ImageCompressorService _compressor;

  @override
  Future<Either<Failure, User>> updateName(String name) => safeCall(
    () async =>
        _cached(await _remote.updateProfile(UpdateProfileRequest(name: name))),
  );

  @override
  Future<Either<Failure, Uint8List>> compressAvatar(String path) =>
      safeCall(() => _compressor.compressAvatar(path));

  @override
  Future<Either<Failure, User>> uploadAvatar(
    Uint8List bytes, {
    void Function(double progress)? onProgress,
  }) => safeCall(
    () async => _cached(
      await _remote.uploadAvatar(
        bytes,
        filename: _avatarFilename,
        onProgress: onProgress,
      ),
    ),
  );

  @override
  Future<Either<Failure, Unit>> removeAvatar() => safeCall(() async {
    await _remote.removeAvatar();
    await _local.clearAvatar();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> deleteAccount(String password) =>
      safeCall(() async {
        await _remote.deleteAccount(DeleteAccountRequest(password: password));
        return unit;
      });

  /// The user in [response], cached.
  Future<User> _cached(MeResponse response) async {
    final row = requireField(response.data).toRow();
    await _local.saveUser(row);
    return row.toEntity();
  }
}
