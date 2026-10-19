/// The newest [limit] transactions of [month] (the first of the month).
class RecentTransactionsParams {
  const RecentTransactionsParams({required this.month, required this.limit});

  final DateTime month;
  final int limit;
}
