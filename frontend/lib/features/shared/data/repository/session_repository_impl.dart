import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/session_remote_datasource.dart';
import 'package:monai/features/shared/domain/repository/session_repository.dart';

class SessionRepositoryImpl extends SessionRepository with BaseRepository {
  SessionRepositoryImpl({required this._remote, required this._local});

  final SessionRemoteDataSource _remote;
  final SessionLocalDataSource _local;

  @override
  Future<Either<Failure, SessionStatus>> logout() => safeCall(() async {
    await _local.endSession();
    return SessionStatus.signedOut;
  });

  @override
  Future<Either<Failure, SessionStatus>> logoutAllDevices() =>
      safeCall(() async {
        await _remote.logoutAll();
        await _local.endSession();
        return SessionStatus.signedOut;
      });
}
