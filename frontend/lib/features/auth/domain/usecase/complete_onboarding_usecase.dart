import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

/// Marks onboarding as finished, so later launches start on Sign in.
class CompleteOnboardingUseCase implements UseCase<bool, NoParams> {
  CompleteOnboardingUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.completeOnboarding();
}
