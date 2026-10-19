import 'dart:async';

import 'package:monai/core/error/exceptions.dart';

/// Mixed into local data sources to centralize cache-error translation.
/// Wraps each local operation, converting any failure into [CacheException].
mixin BaseLocalDataSource {
  /// Runs [op]; any throw becomes a [CacheException]. An already-typed
  /// [CacheException] passes through unchanged.
  Future<T> safeCacheCall<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  /// The stream [watch] opens, with every error turned into a
  /// [CacheException].
  Stream<T> safeCacheStream<T>(Stream<T> Function() watch) {
    final Stream<T> source;
    try {
      source = watch();
    } catch (e) {
      return Stream.error(_toCacheException(e));
    }
    return source.transform(
      StreamTransformer.fromHandlers(
        handleError: (error, stackTrace, sink) =>
            sink.addError(_toCacheException(error), stackTrace),
      ),
    );
  }

  CacheException _toCacheException(Object error) => error is CacheException
      ? error
      : CacheException(message: error.toString());
}
