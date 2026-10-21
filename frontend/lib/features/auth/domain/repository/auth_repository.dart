import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';

/// Onboarding and the user's session. A successful login or register stores
/// the new token and marks the session signed in; navigation follows the
/// session from there. Input is sent as given: the use cases have already
/// cleaned it up and validated it.
abstract class AuthRepository {
  /// Whether onboarding was finished on this device.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Remembers that onboarding was finished; gives the stored flag, true.
  Future<Either<Failure, bool>> completeOnboarding();

  /// Signs in with an existing account and gives the new session.
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  /// Creates an account, signs in to it and gives the new session.
  Future<Either<Failure, AuthSession>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Changes the password, which revokes every token, then signs out here so
  /// the user signs in again with the new one. A wrong [currentPassword]
  /// fails with code `invalid_password`. Gives
  /// [SessionStatus.passwordChanged].
  Future<Either<Failure, SessionStatus>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Resumes the stored session at launch; true when one exists.
  Future<Either<Failure, bool>> restoreSession();
}
