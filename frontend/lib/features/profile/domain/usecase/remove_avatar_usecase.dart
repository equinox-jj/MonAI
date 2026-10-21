import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';

class RemoveAvatarUseCase implements UseCase<Unit, NoParams> {
  RemoveAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.removeAvatar();
}
