import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';

/// A fresh in-memory database; close it in `tearDown`.
MonAIDatabase openTestDatabase() => MonAIDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

final _timestamp = DateTime.utc(2026, 10, 1, 8);

WalletRow walletRow({
  String id = 'w1',
  String name = 'Cash',
  bool isDefault = false,
}) => WalletRow(
  id: id,
  name: name,
  type: WalletType.cash,
  initialBalance: 0,
  currentBalance: 100000,
  isDefault: isDefault,
  isArchived: false,
  createdAt: _timestamp,
  updatedAt: _timestamp,
);

CategoryRow categoryRow({
  String id = 'c1',
  String name = 'Food',
  CategoryType type = CategoryType.expense,
}) => CategoryRow(
  id: id,
  name: name,
  type: type,
  isDefault: false,
  isSystem: false,
  isHidden: false,
  createdAt: _timestamp,
  updatedAt: _timestamp,
);

TransactionRow transactionRow({
  String id = 't1',
  TransactionType type = TransactionType.expense,
  int amount = 10000,
  String walletId = 'w1',
  String? toWalletId,
  String? categoryId = 'c1',
  DateTime? date,
  String? note,
  String? merchant,
  DateTime? updatedAt,
}) => TransactionRow(
  id: id,
  type: type,
  amount: amount,
  walletId: walletId,
  toWalletId: toWalletId,
  categoryId: categoryId,
  date: date ?? DateTime(2026, 10, 1),
  note: note,
  merchant: merchant,
  source: TransactionSource.manual,
  createdAt: _timestamp,
  updatedAt: updatedAt ?? _timestamp,
);

BudgetRow budgetRow({DateTime? month, int limitAmount = 1000000}) => BudgetRow(
  month: month ?? DateTime(2026, 10),
  limitAmount: limitAmount,
  spent: 0,
  remaining: limitAmount,
  progressPercent: 0,
  status: BudgetStatus.ok,
);

PaymentProviderRow paymentProviderRow({
  String id = 'p1',
  String name = 'BCA',
  int sortOrder = 0,
}) => PaymentProviderRow(
  id: id,
  slug: name.toLowerCase(),
  name: name,
  type: WalletType.bank,
  aliases: const ['bank central asia'],
  sortOrder: sortOrder,
);

MonthlyReportRow monthlyReportRow({DateTime? month}) => MonthlyReportRow(
  month: month ?? DateTime(2026, 10),
  incomeTotal: 500000,
  expenseTotal: 200000,
  net: 300000,
  previousMonth: DateTime(2026, 9),
  previousIncomeTotal: 400000,
  previousExpenseTotal: 100000,
  expenseChangePercent: 100,
);

ReportCategoryRow reportCategoryRow({
  DateTime? month,
  String categoryId = 'c1',
  int position = 0,
}) => ReportCategoryRow(
  month: month ?? DateTime(2026, 10),
  categoryId: categoryId,
  position: position,
  name: 'Food',
  amount: 200000,
  sharePercent: 100,
  previousAmount: 100000,
);

UserRow userRow({String id = 'u1'}) => UserRow(
  id: id,
  name: 'Budi',
  email: 'budi@example.com',
  timezone: 'Asia/Jakarta',
  roleSlug: 'user',
  roleName: 'User',
  permissions: const ['transactions.read'],
  createdAt: _timestamp,
);
