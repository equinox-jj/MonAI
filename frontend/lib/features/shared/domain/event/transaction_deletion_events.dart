import 'dart:async';

import 'package:monai/features/shared/domain/entity/transaction.dart';

/// Transactions deleted anywhere in the app, so the screen showing them can
/// offer an undo. Emitted by the delete use case after the delete succeeds.
/// Registered once, for the whole app.
class TransactionDeletionEvents {
  final _controller = StreamController<Transaction>.broadcast();

  /// Each deleted transaction, as it was before the delete.
  Stream<Transaction> get stream => _controller.stream;

  /// Announces that [transaction] was deleted.
  void emit(Transaction transaction) => _controller.add(transaction);

  Future<void> dispose() => _controller.close();
}
