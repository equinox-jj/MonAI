import 'package:monai/core/model/budget_status.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/shared/domain/entity/budget.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/monthly_report.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

final _timestamp = DateTime.utc(2026, 10, 1, 8);

Wallet wallet({
  String id = 'w1',
  String name = 'Cash',
  WalletType type = WalletType.cash,
  int initialBalance = 0,
  int currentBalance = 100000,
  String? providerId,
  String? color,
  bool isDefault = false,
  bool isArchived = false,
}) => Wallet(
  id: id,
  providerId: providerId,
  name: name,
  type: type,
  initialBalance: initialBalance,
  currentBalance: currentBalance,
  color: color,
  isDefault: isDefault,
  isArchived: isArchived,
  createdAt: _timestamp,
  updatedAt: _timestamp,
);

Transaction transaction({
  String id = 't1',
  TransactionType type = TransactionType.expense,
  int amount = 10000,
  String walletId = 'w1',
  String? categoryId = 'c1',
  String? toWalletId,
  String? note,
  String? merchant,
  DateTime? date,
  DateTime? createdAt,
  TransactionSource source = TransactionSource.manual,
  String? receiptUrl,
}) => Transaction(
  id: id,
  type: type,
  amount: amount,
  walletId: walletId,
  toWalletId: toWalletId,
  categoryId: categoryId,
  note: note,
  merchant: merchant,
  date: date ?? DateTime(2026, 10, 1),
  source: source,
  receiptUrl: receiptUrl,
  createdAt: createdAt ?? _timestamp,
  updatedAt: _timestamp,
);

User user({String id = 'u1', String name = 'Ana'}) => User(
  id: id,
  name: name,
  email: 'ana@monai.id',
  timezone: 'Asia/Jakarta',
  role: const UserRole(slug: 'user', name: 'User'),
  permissions: const {},
  createdAt: _timestamp,
);

AuthSession authSession({String accessToken = 'token'}) => AuthSession(
  accessToken: accessToken,
  tokenType: 'Bearer',
  expiresIn: const Duration(hours: 1),
  user: user(),
);

Budget budget({DateTime? month}) => Budget(
  month: month ?? DateTime(2026, 10),
  limitAmount: 1000000,
  spent: 250000,
  remaining: 750000,
  progressPercent: 25,
  status: BudgetStatus.ok,
);

MonthlyReport monthlyReport({
  DateTime? month,
  List<CategoryBreakdown> categories = const [],
  double? expenseChangePercent,
}) => MonthlyReport(
  month: month ?? DateTime(2026, 10),
  incomeTotal: 5000000,
  expenseTotal: 250000,
  net: 4750000,
  previous: PreviousMonthTotals(
    month: DateTime(2026, 9),
    incomeTotal: 0,
    expenseTotal: 0,
  ),
  categories: categories,
  expenseChangePercent: expenseChangePercent,
);

Category category({
  String id = 'c1',
  String name = 'Food',
  String? icon = 'restaurant',
  String? color = '#F97316',
  CategoryType type = CategoryType.expense,
  bool isHidden = false,
  bool isDefault = true,
  bool isSystem = false,
}) => Category(
  id: id,
  name: name,
  type: type,
  isDefault: isDefault,
  isSystem: isSystem,
  isHidden: isHidden,
  icon: icon,
  color: color,
  createdAt: _timestamp,
  updatedAt: _timestamp,
);

CategoryBreakdown categoryBreakdown({
  String id = 'c1',
  String name = 'Food',
  int amount = 100000,
  double sharePercent = 40,
  double? changePercent,
}) => CategoryBreakdown(
  categoryId: id,
  name: name,
  amount: amount,
  sharePercent: sharePercent,
  previousAmount: 0,
  color: '#F97316',
  changePercent: changePercent,
);

PaymentProvider paymentProvider({
  String id = 'p1',
  String? slug,
  String name = 'GoPay',
  WalletType type = WalletType.eWallet,
  List<String> aliases = const [],
}) => PaymentProvider(
  id: id,
  slug: slug ?? id,
  name: name,
  type: type,
  aliases: aliases,
  sortOrder: 0,
);
