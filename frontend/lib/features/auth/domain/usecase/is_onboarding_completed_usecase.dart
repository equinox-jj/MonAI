import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

/// Whether onboarding was finished, which decides if the app opens on
/// onboarding or on Sign in.
class IsOnboardingCompletedUseCase implements UseCase<bool, NoParams> {
  IsOnboardingCompletedUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.isOnboardingCompleted();
}
