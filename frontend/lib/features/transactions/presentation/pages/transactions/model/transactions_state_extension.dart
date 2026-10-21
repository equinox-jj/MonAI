import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/transactions/presentation/model/transaction_list_item.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/bloc/transactions_bloc.dart';

extension TransactionsStateX on TransactionsState {
  DateTime get currentMonth => monthOf(today);

  bool get canShowNextMonth => month.isBefore(currentMonth);

  bool get hasFilter => filter != const TransactionFilter();

  List<Transaction> get visibleTransactions => deletingIds.isEmpty
      ? transactions
      : transactions.where((t) => !deletingIds.contains(t.id)).toList();

  List<TransactionListItem> get items =>
      groupByDay(visibleTransactions, dailyNets: dailyNets);
}
