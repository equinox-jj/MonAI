/// Central registry of the API base URL and `RequestOptions.extra` keys.
/// Feature paths live in each feature's
/// `data/datasources/endpoint/*_endpoint.dart`.
class ApiEndpoints {
  const ApiEndpoints._();

  /// Base URL for all requests. Override per build with
  /// `--dart-define=API_BASE_URL=http://localhost:8080/api/v1`.
  /// `--dart-define=API_BASE_URL=https://monai.my.id/api/v1`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// `extra` flag: skip attaching the access token (login/register).
  static const String kNoAuth = 'noAuth';
}
