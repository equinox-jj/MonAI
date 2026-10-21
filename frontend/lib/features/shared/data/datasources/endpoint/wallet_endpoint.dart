abstract final class WalletEndpoint {
  static const wallets = '/wallets';

  static String wallet(String id) => '/wallets/$id';
}
