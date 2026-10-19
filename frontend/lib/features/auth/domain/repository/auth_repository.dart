import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';

/// Onboarding and the user's session. A successful login or register stores
/// the new token and marks the session signed in; navigation follows the
/// session from there. Input is sent as given: the use cases have already
/// cleaned it up and validated it.
abstract class AuthRepository {
  /// Whether onboarding was finished on this device.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Remembers that onboarding was finished.
  Future<Either<Failure, Unit>> completeOnboarding();

  /// Signs in with an existing account.
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  });

  /// Creates an account and signs in to it.
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Signs out of this device only; the token stays valid on the server
  /// until it expires. Fails only when the token could not be removed, and
  /// the user is then still signed in.
  Future<Either<Failure, Unit>> logout();

  /// Resumes the stored session at launch; true when one exists.
  Future<Either<Failure, bool>> restoreSession();
}
