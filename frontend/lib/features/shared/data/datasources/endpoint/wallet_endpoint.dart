/// Wallet API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class WalletEndpoint {
  /// `GET`: every wallet; `POST`: create one.
  static const wallets = '/wallets';

  /// `GET`, `PATCH`, `DELETE`: one wallet.
  static String wallet(String id) => '/wallets/$id';
}
