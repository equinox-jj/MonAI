/// Payment provider API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class PaymentProviderEndpoint {
  /// `GET`: the active catalog, with ETag caching.
  static const catalog = '/payment-providers';
}
