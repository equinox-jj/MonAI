import 'package:monai/core/utils/month_format.dart';
import 'package:monai/core/utils/monograms.dart';
import 'package:monai/features/home/domain/entity/home_dashboard.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

const kRecentTransactionLimit = 5;
const kMaxSpendingSlices = 5;

HomeGreeting greetingFor(DateTime now) => switch (now.hour) {
  >= 5 && < 12 => .morning,
  >= 12 && < 18 => .afternoon,
  _ => .evening,
};

int daysLeftInMonth(DateTime today) {
  final lastDay = DateTime(today.year, today.month + 1, 0).day;
  return lastDay - today.day;
}

int totalBalance(List<Wallet> wallets) => wallets
    .where((w) => !w.isArchived)
    .fold(0, (sum, w) => sum + w.currentBalance);

List<Wallet> visibleWallets(List<Wallet> wallets) {
  final active = wallets.where((w) => !w.isArchived);
  return [
    ...active.where((w) => w.isDefault),
    ...active.where((w) => !w.isDefault),
  ];
}

MonthSummary toSummary(MonthlyReport report) => MonthSummary(
  incomeTotal: report.incomeTotal,
  expenseTotal: report.expenseTotal,
  previousMonth: report.previous.month,
  expenseChangePercent: report.expenseChangePercent,
);

/// The largest categories with spending, the rest folded into one "Others"
/// slice once there are more than [kMaxSpendingSlices].
List<SpendingSlice> toSpendingSlices(List<CategoryBreakdown> categories) {
  final spent = categories.where((c) => c.amount > 0).toList();
  if (spent.length <= kMaxSpendingSlices) {
    return spent.map(_toSlice).toList();
  }
  final rest = spent.skip(kMaxSpendingSlices - 1);
  return [
    ...spent.take(kMaxSpendingSlices - 1).map(_toSlice),
    SpendingSlice(
      amount: rest.fold(0, (sum, c) => sum + c.amount),
      sharePercent: rest.fold(0, (sum, c) => sum + c.sharePercent),
    ),
  ];
}

SpendingSlice _toSlice(CategoryBreakdown c) => SpendingSlice(
  categoryId: c.categoryId,
  name: c.name,
  color: c.color,
  amount: c.amount,
  sharePercent: c.sharePercent,
);

RecentTransaction toRecent(
  Transaction transaction, {
  required Map<String, Category> categoriesById,
  required Map<String, Wallet> walletsById,
  required DateTime now,
}) {
  final category = categoriesById[transaction.categoryId];
  return RecentTransaction(
    id: transaction.id,
    type: transaction.type,
    amount: transaction.amount,
    title: [
      transaction.note,
      transaction.merchant,
      category?.name,
    ].firstWhere((t) => t != null && t.trim().isNotEmpty, orElse: () => null),
    categoryName: category?.name,
    icon: category?.icon,
    color: category?.color,
    walletName: walletsById[transaction.walletId]?.name,
    toWalletName: walletsById[transaction.toWalletId]?.name,
    day: _dayOf(transaction, now),
  );
}

RecentDay _dayOf(Transaction transaction, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final date = transaction.date;
  final day = DateTime(date.year, date.month, date.day);
  if (day == today) return RecentDay.today(transaction.createdAt.toLocal());
  if (day == DateTime(today.year, today.month, today.day - 1)) {
    return const RecentDay.yesterday();
  }
  return RecentDay.earlier(day);
}

HomeDashboard buildHomeDashboard({
  required DateTime now,
  required User? user,
  required List<Wallet> wallets,
  required List<Category> categories,
  required List<Transaction> recent,
  required Budget? budget,
  required MonthlyReport? report,
}) {
  final categoriesById = {for (final c in categories) c.id: c};
  final walletsById = {for (final w in wallets) w.id: w};
  final name = user?.name ?? '';
  return HomeDashboard(
    month: monthOf(now),
    greeting: greetingFor(now),
    userName: name,
    initials: initialsOf(name),
    avatarUrl: user?.avatarUrl,
    hasCache: user != null || wallets.isNotEmpty,
    totalBalance: totalBalance(wallets),
    wallets: visibleWallets(wallets),
    daysLeftInMonth: daysLeftInMonth(now),
    summary: report == null ? null : toSummary(report),
    budget: budget,
    spending: toSpendingSlices(report?.categories ?? const []),
    recent: recent
        .map(
          (t) => toRecent(
            t,
            categoriesById: categoriesById,
            walletsById: walletsById,
            now: now,
          ),
        )
        .toList(),
  );
}
