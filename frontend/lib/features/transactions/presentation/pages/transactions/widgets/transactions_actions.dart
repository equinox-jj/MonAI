import 'package:flutter/foundation.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_filter_chips.dart';

@immutable
class TransactionsActions {
  const TransactionsActions({
    required this.onSearch,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onOpenFilter,
    required this.onClearFilters,
    required this.onOpenTransaction,
    required this.onDeleteTransaction,
    required this.onAddTransaction,
    required this.onRetry,
  });

  final VoidCallback onSearch;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<TransactionFilterKind> onOpenFilter;
  final VoidCallback onClearFilters;
  final ValueChanged<String> onOpenTransaction;
  final ValueChanged<String> onDeleteTransaction;
  final VoidCallback onAddTransaction;
  final VoidCallback onRetry;
}
