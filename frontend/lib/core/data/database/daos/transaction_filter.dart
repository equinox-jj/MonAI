import 'package:monai/core/model/transaction_type.dart';

/// [from] and [to] are inclusive; a null filter matches everything.
/// [walletId] matches the source or destination wallet, like
/// `GET /transactions`.
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
