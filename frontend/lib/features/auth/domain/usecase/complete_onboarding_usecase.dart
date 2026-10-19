import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

/// Marks onboarding as finished, so later launches start on Sign in.
class CompleteOnboardingUseCase implements UseCase<Unit, NoParams> {
  CompleteOnboardingUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.completeOnboarding();
}
