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
}
