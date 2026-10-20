/// Auth API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class AuthEndpoint {
  /// `POST`: sign in with email and password.
  static const login = '/auth/login';

  /// `POST`: create an account and sign in.
  static const register = '/auth/register';

  /// `PUT`: change the password; revokes every older token.
  static const password = '/auth/password';
}
