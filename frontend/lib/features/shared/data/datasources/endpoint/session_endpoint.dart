/// Session API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class SessionEndpoint {
  /// `POST`: revoke every token of the account, on all devices.
  static const logoutAll = '/auth/logout-all';
}
