import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class TokenStorage {
  Future<String?> readAccessToken();

  Future<void> saveAccessToken(String accessToken);

  Future<void> clear();
}

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
