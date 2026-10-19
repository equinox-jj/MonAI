import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository with BaseRepository {
  AuthRepositoryImpl({required this._local});

  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() =>
      safeCall(_local.isOnboardingCompleted);

  @override
  Future<Either<Failure, Unit>> completeOnboarding() => safeCall(() async {
    await _local.markOnboardingCompleted();
    return unit;
  });
}
