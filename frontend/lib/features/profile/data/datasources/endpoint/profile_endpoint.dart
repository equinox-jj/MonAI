/// Profile API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class ProfileEndpoint {
  /// `PATCH`: the display name. `DELETE`: the account, with the password.
  static const me = '/me';

  /// `PUT`: a new profile photo, multipart `file`. `DELETE`: remove it.
  static const avatar = '/me/avatar';
}
