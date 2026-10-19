/// Transaction API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class TransactionEndpoint {
  /// `GET`: one month's cursor page; `POST`: create one.
  static const transactions = '/transactions';

  /// `POST`: upload a receipt photo (multipart `file`).
  static const receipt = '/transactions/receipt';

  /// `GET`, `PATCH`, `DELETE`: one transaction.
  static String transaction(String id) => '/transactions/$id';

  /// `POST`: undo a delete.
  static String restore(String id) => '/transactions/$id/restore';
}
