import 'package:monai/features/shared/domain/entity/transaction_filter.dart';

class TransactionListParams {
  const TransactionListParams({
    required this.month,
    this.filter = const TransactionFilter(),
  });

  final DateTime month;
  final TransactionFilter filter;
}

class TransactionPageParams extends TransactionListParams {
  const TransactionPageParams({
    required super.month,
    required this.limit,
    super.filter,
  });

  final int limit;
}
