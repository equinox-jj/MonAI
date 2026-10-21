import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/repository/user_repository.dart';

class RefreshUserUseCase implements UseCase<User, NoParams> {
  RefreshUserUseCase(this._repository);

  final UserRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      _repository.refreshUser();
}
