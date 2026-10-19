import 'package:monai/core/model/transaction_type.dart';

/// Which cached transactions a list shows: those dated from [from] to [to]
/// (inclusive) that match every non-null filter. [walletId] matches the
/// source or destination wallet, like `GET /transactions`.
class TransactionFilter {
  const TransactionFilter({
    required this.from,
    required this.to,
    this.walletId,
    this.categoryId,
    this.type,
  });

  final DateTime from;
  final DateTime to;
  final String? walletId;
  final String? categoryId;
  final TransactionType? type;
}
