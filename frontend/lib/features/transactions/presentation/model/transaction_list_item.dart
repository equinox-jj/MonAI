import 'package:monai/features/shared/domain/entity/transaction.dart';

sealed class TransactionListItem {
  const TransactionListItem();
}

final class TransactionDayItem extends TransactionListItem {
  const TransactionDayItem(this.date, {this.net});

  final DateTime date;
  final int? net;
}

final class TransactionEntryItem extends TransactionListItem {
  const TransactionEntryItem(this.transaction, {required this.isLastOfDay});

  final Transaction transaction;
  final bool isLastOfDay;
}

List<TransactionListItem> groupByDay(
  List<Transaction> transactions, {
  Map<DateTime, int>? dailyNets,
}) {
  final items = <TransactionListItem>[];
  for (final (index, transaction) in transactions.indexed) {
    final day = transaction.date;
    if (index == 0 || transactions[index - 1].date != day) {
      items.add(TransactionDayItem(day, net: dailyNets?[day]));
    }
    final next = index + 1 < transactions.length
        ? transactions[index + 1]
        : null;
    items.add(
      TransactionEntryItem(transaction, isLastOfDay: next?.date != day),
    );
  }
  return items;
}
