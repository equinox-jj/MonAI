import 'package:fpdart/fpdart.dart';

import 'package:monai/core/error/failure.dart';

/// Base type for a single business operation.
///
/// [T] is the success value; [Params] is the input (use [NoParams] for none).
abstract class UseCase<T, Params> {
  /// Executes the operation.
  Future<Either<Failure, T>> call(Params params);
}

/// Placeholder for use-cases that take no input.
class NoParams {
  const NoParams();
}
