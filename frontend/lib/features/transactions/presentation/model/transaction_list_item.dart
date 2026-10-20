import 'package:monai/features/shared/domain/entity/transaction.dart';

/// A row of a day-grouped transaction list: a day header above its
/// transactions, or a transaction.
sealed class TransactionListItem {
  const TransactionListItem();
}

/// The header of [date] (local midnight); [net] is the day's income minus
/// expenses, null when unknown (e.g. search results).
final class TransactionDayItem extends TransactionListItem {
  const TransactionDayItem(this.date, {this.net});

  final DateTime date;
  final int? net;
}

/// A transaction; [isLastOfDay] ends its day's group, so it draws no divider.
final class TransactionEntryItem extends TransactionListItem {
  const TransactionEntryItem(this.transaction, {required this.isLastOfDay});

  final Transaction transaction;
  final bool isLastOfDay;
}

/// Puts a header before each day of [transactions], which come newest first,
/// with that day's net from [dailyNets] when given.
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
