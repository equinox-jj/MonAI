import 'dart:async';

import 'package:monai/features/shared/domain/entity/transaction.dart';

/// Lets the screen showing a deleted transaction offer an undo. Emitted by the
/// delete use case after the delete succeeds; registered once for the whole
/// app.
class TransactionDeletionEvents {
  final _controller = StreamController<Transaction>.broadcast();

  Stream<Transaction> get stream => _controller.stream;

  void emit(Transaction transaction) => _controller.add(transaction);

  Future<void> dispose() => _controller.close();
}
