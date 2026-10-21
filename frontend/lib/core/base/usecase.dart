import 'package:fpdart/fpdart.dart';

import 'package:monai/core/base/error/failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Observes data that changes over time (usually the cache). The stream keeps
/// going after a [Failure].
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
