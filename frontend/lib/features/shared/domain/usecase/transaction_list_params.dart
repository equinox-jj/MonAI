import 'package:monai/features/shared/domain/entity/transaction_filter.dart';

/// One transaction list: [month] (the first of the month) narrowed by
/// [filter].
class TransactionListParams {
  const TransactionListParams({
    required this.month,
    this.filter = const TransactionFilter(),
  });

  final DateTime month;
  final TransactionFilter filter;
}

/// The first [limit] rows of a transaction list.
class TransactionPageParams extends TransactionListParams {
  const TransactionPageParams({
    required super.month,
    required this.limit,
    super.filter,
  });

  final int limit;
}
