import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// The signed-in user.
abstract class UserRepository {
  /// The cached user, or null before the first fetch.
  Stream<Either<Failure, User?>> watchUser();

  /// Re-fetches the user and gives the cached copy.
  Future<Either<Failure, User>> refreshUser();
}
