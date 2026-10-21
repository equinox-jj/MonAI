/// Admin payment provider API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class AdminProviderEndpoint {
  /// `GET` (paged, every status) and `POST`.
  static const providers = '/admin/payment-providers';

  /// `GET`, `PATCH` and `DELETE` of provider [id].
  static String provider(String id) => '$providers/$id';

  /// `PATCH`: activate or deactivate provider [id].
  static String status(String id) => '$providers/$id/status';

  /// `PUT`, multipart `file`: provider [id]'s logo.
  static String logo(String id) => '$providers/$id/logo';
}
