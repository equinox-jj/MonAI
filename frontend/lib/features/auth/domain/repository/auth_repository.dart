import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';

/// A successful login or register stores the token and marks the session
/// signed in; navigation follows the session. Input is sent as given: the use
/// cases have already cleaned it up and validated it.
abstract class AuthRepository {
  Future<Either<Failure, bool>> isOnboardingCompleted();

  Future<Either<Failure, bool>> completeOnboarding();

  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Revokes every token, then signs out here so the user signs in with the new
  /// password. A wrong [currentPassword] fails with `invalid_password`.
  Future<Either<Failure, SessionStatus>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> restoreSession();
}
