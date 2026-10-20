import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// Renames the user. An invalid name fails as [ValidationFailure] without
/// calling the server.
class UpdateProfileNameUseCase implements UseCase<User, String> {
  UpdateProfileNameUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, User>> call(String params) async {
    final name = ProfileInputValidator.normalizedName(params);
    if (ProfileInputValidator.name(name) case final error?) {
      return Left(Failure.validation([error]));
    }
    return _repository.updateName(name);
  }
}
