import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the access token. Domain code depends on this abstraction.
abstract interface class TokenStorage {
  /// Returns the stored access token, or null if absent.
  Future<String?> readAccessToken();

  /// Persists [accessToken], replacing any previous one.
  Future<void> saveAccessToken(String accessToken);

  /// Removes the stored token.
  Future<void> clear();
}

/// [TokenStorage] backed by encrypted [FlutterSecureStorage]
/// (Keychain on iOS, EncryptedSharedPreferences/Keystore on Android).
class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<void> saveAccessToken(String accessToken) =>
      _storage.write(key: _kAccess, value: accessToken);

  @override
  Future<void> clear() => _storage.delete(key: _kAccess);
}
