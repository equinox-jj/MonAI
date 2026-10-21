abstract final class TransactionEndpoint {
  static const transactions = '/transactions';
  static const receipt = '/transactions/receipt';

  static String transaction(String id) => '/transactions/$id';

  static String restore(String id) => '/transactions/$id/restore';
}
