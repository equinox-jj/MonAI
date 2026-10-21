class ApiEndpoints {
  const ApiEndpoints._();

  /// Override per build with
  /// `--dart-define=API_BASE_URL=http://localhost:8080/api/v1`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// `extra` flag for login/register: no access token is attached, and a 401
  /// doesn't end the session.
  static const String kNoAuth = 'noAuth';
}
