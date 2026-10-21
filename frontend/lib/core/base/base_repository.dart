import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:monai/core/base/error/error_mapper.dart';

/// The single boundary where thrown exceptions become an `Either` [Failure].
mixin BaseRepository {
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() body) async {
    try {
      final value = await body();
      return Right(value);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  /// Errors become `Left` events; the stream keeps going after one.
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
