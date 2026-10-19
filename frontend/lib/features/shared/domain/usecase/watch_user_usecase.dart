import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/repository/user_repository.dart';

/// The signed-in user; null before the first fetch.
class WatchUserUseCase implements StreamUseCase<User?, NoParams> {
  WatchUserUseCase(this._repository);

  final UserRepository _repository;

  @override
  Stream<Either<Failure, User?>> call(NoParams params) =>
      _repository.watchUser();
}
