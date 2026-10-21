import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/base_repository.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/mapper/auth_mapper.dart';
import 'package:monai/features/auth/data/model/auth_response.dart';
import 'package:monai/features/auth/data/model/change_password_request.dart';
import 'package:monai/features/auth/data/model/login_request.dart';
import 'package:monai/features/auth/data/model/register_request.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/shared/data/datasources/session_local_datasource.dart';
import 'package:monai/features/shared/data/datasources/user_local_datasource.dart';
import 'package:monai/features/shared/data/mapper/user_mapper.dart';

class AuthRepositoryImpl extends AuthRepository with BaseRepository {
  AuthRepositoryImpl({
    required this._remote,
    required this._local,
    required this._users,
    required this._session,
  });

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final UserLocalDataSource _users;
  final SessionLocalDataSource _session;

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() =>
      safeCall(_local.isOnboardingCompleted);

  @override
  Future<Either<Failure, bool>> completeOnboarding() => safeCall(() async {
    await _local.markOnboardingCompleted();
    return true;
  });

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) => _signIn(
    () => _remote.login(LoginRequest(email: email, password: password)),
  );

  @override
  Future<Either<Failure, AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) => _signIn(
    () => _remote.register(
      RegisterRequest(name: name, email: email, password: password),
    ),
  );

  // The response carries a fresh token for this device. It is dropped on
  // purpose, as on Android: the user signs in again with the new password.
  @override
  Future<Either<Failure, SessionStatus>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => safeCall(() async {
    await _remote.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    await _session.endSessionAfterPasswordChange();
    return SessionStatus.passwordChanged;
  });

  @override
  Future<Either<Failure, bool>> restoreSession() =>
      safeCall(_local.restoreSession);

  Future<Either<Failure, AuthSession>> _signIn(
    Future<AuthResponse> Function() request,
  ) => safeCall(() async {
    // Mapped first: a malformed payload must not leave a half-started
    // session.
    final session = (await request()).toEntity();
    // Drop anything cached for a previous account before the new session
    // starts.
    await _local.clearCache();
    // Cached before the session starts, so Home has the user at once. Best
    // effort: the next user refresh fills a cache that failed to save.
    try {
      await _users.replace(session.user.toRow());
    } on CacheException catch (_) {}
    await _local.startSession(session.accessToken);
    return session;
  });
}
