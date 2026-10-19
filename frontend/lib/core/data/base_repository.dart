import 'dart:async';

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

  /// Wraps each value of the stream [watch] opens in `Right`, and turns each
  /// error, including one thrown while opening it, into a `Left(Failure)`
  /// event. The stream keeps going after an error.
  Stream<Either<Failure, T>> safeStream<T>(Stream<T> Function() watch) {
    final Stream<T> source;
    try {
      source = watch();
    } catch (e) {
      return Stream.value(Left(mapExceptionToFailure(e)));
    }
    return source.transform(
      StreamTransformer.fromHandlers(
        handleData: (value, sink) => sink.add(Right(value)),
        handleError: (error, _, sink) =>
            sink.add(Left(mapExceptionToFailure(error))),
      ),
    );
  }
}
