import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/model/auth_response.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository with BaseRepository {
  AuthRepositoryImpl({required this._remote, required this._local});

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() =>
      safeCall(_local.isOnboardingCompleted);

  @override
  Future<Either<Failure, Unit>> completeOnboarding() => safeCall(() async {
    await _local.markOnboardingCompleted();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  }) => _signIn(
    () => _remote.login(LoginRequest(email: email, password: password)),
  );

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  }) => _signIn(
    () => _remote.register(
      RegisterRequest(name: name, email: email, password: password),
    ),
  );

  @override
  Future<Either<Failure, Unit>> logout() => safeCall(() async {
    await _local.endSession();
    return unit;
  });

  @override
  Future<Either<Failure, bool>> restoreSession() =>
      safeCall(_local.restoreSession);

  Future<Either<Failure, Unit>> _signIn(
    Future<AuthResponse> Function() request,
  ) => safeCall(() async {
    final response = await request();
    // Checked first: a payload without a token must not leave a half-started
    // session.
    final token = response.data?.accessToken;
    if (token == null || token.isEmpty) {
      throw const UnknownException(message: 'Malformed response');
    }
    // Drop anything cached for a previous account before the new session
    // starts.
    await _local.clearCache();
    await _local.startSession(token);
    return unit;
  });
}
