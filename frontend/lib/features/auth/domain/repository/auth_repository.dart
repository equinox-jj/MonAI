import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';

abstract class AuthRepository {
  /// Whether onboarding was finished on this device.
  Future<Either<Failure, bool>> isOnboardingCompleted();

  /// Remembers that onboarding was finished.
  Future<Either<Failure, Unit>> completeOnboarding();
}
