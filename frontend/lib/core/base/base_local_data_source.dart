import 'dart:async';

import 'package:monai/core/base/error/exceptions.dart';

/// Mixed into local data sources: any failure becomes a [CacheException].
mixin BaseLocalDataSource {
  Future<T> safeCacheCall<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

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
