import 'package:fpdart/fpdart.dart';

import 'package:monai/core/error/error_mapper.dart';

/// Mixed into repository implementations to centralize the try/catch that
/// converts thrown exceptions into a domain [Failure]. This is the single
/// boundary where exceptions stop and `Either` begins.
mixin BaseRepository {
  /// Runs [body], returning `Right` on success or `Left(Failure)` on any throw.
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() body) async {
    try {
      final value = await body();
      return Right(value);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
