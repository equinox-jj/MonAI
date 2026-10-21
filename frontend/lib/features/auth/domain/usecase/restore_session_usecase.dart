import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';

/// Resumes the stored session at launch. True when the user is signed in,
/// which decides whether the app opens on Home.
class RestoreSessionUseCase implements UseCase<bool, NoParams> {
  RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      _repository.restoreSession();
}
