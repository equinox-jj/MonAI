import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

abstract class UserRepository {
  Stream<Either<Failure, User?>> watchUser();

  Future<Either<Failure, User>> refreshUser();
}
