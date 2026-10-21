abstract final class AdminProviderEndpoint {
  static const providers = '/admin/payment-providers';

  static String provider(String id) => '$providers/$id';

  static String status(String id) => '$providers/$id/status';

  static String logo(String id) => '$providers/$id/logo';
}
