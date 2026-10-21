import 'package:fpdart/fpdart.dart';

import 'package:monai/core/base/error/failure.dart';

/// Base type for a single business operation.
///
/// [T] is the success value; [Params] is the input (use [NoParams] for none).
abstract class UseCase<T, Params> {
  /// Executes the operation.
  Future<Either<Failure, T>> call(Params params);
}

/// Base type for an observation of data that changes over time, typically the
/// local cache.
///
/// Each event is the latest [T], or a [Failure] when reading it failed; the
/// stream keeps going after a failure.
abstract class StreamUseCase<T, Params> {
  /// Starts observing.
  Stream<Either<Failure, T>> call(Params params);
}

/// Placeholder for use-cases that take no input.
class NoParams {
  const NoParams();
}
