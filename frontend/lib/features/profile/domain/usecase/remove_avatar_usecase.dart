import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';

/// Removes the profile photo; the initials show instead.
class RemoveAvatarUseCase implements UseCase<Unit, NoParams> {
  RemoveAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.removeAvatar();
}
