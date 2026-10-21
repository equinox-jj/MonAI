import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/core/model/budget_status.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/model/wallet_type.dart';

// The API's wire values for the core enums and dates. A value the app doesn't
// know (or a missing required field) fails as a malformed response.

const _date = DateOnlyConverter();
const _month = YearMonthConverter();

Never malformed() =>
    throw const UnknownException(message: 'Malformed response');

T requireField<T>(T? value) => value ?? malformed();

DateTime parseApiDate(String? value) =>
    DateTime.tryParse(requireField(value)) ?? malformed();

String formatApiDate(DateTime date) => _date.toSql(date);

DateTime parseApiMonth(String? value) {
  final raw = requireField(value);
  if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(raw)) malformed();
  return _month.fromSql(raw);
}

String formatApiMonth(DateTime month) => _month.toSql(month);

const _walletTypes = {
  'CASH': WalletType.cash,
  'BANK': WalletType.bank,
  'E_WALLET': WalletType.eWallet,
  'OTHER': WalletType.other,
};

const _transactionTypes = {
  'EXPENSE': TransactionType.expense,
  'INCOME': TransactionType.income,
  'TRANSFER': TransactionType.transfer,
};

const _transactionSources = {
  'MANUAL': TransactionSource.manual,
  'QUICK_ADD': TransactionSource.quickAdd,
  'RECEIPT': TransactionSource.receipt,
};

const _categoryTypes = {
  'EXPENSE': CategoryType.expense,
  'INCOME': CategoryType.income,
};

const _budgetStatuses = {
  'OK': BudgetStatus.ok,
  'WARNING': BudgetStatus.warning,
  'EXCEEDED': BudgetStatus.exceeded,
};

T _parse<T>(Map<String, T> values, String? value) =>
    values[value] ?? malformed();

String _format<T>(Map<String, T> values, T value) =>
    values.entries.firstWhere((entry) => entry.value == value).key;

WalletType parseWalletType(String? value) => _parse(_walletTypes, value);

TransactionType parseTransactionType(String? value) =>
    _parse(_transactionTypes, value);

TransactionSource parseTransactionSource(String? value) =>
    _parse(_transactionSources, value);

CategoryType parseCategoryType(String? value) => _parse(_categoryTypes, value);

BudgetStatus parseBudgetStatus(String? value) => _parse(_budgetStatuses, value);

extension WalletTypeApi on WalletType {
  String get apiValue => _format(_walletTypes, this);
}

extension TransactionTypeApi on TransactionType {
  String get apiValue => _format(_transactionTypes, this);
}

extension TransactionSourceApi on TransactionSource {
  String get apiValue => _format(_transactionSources, this);
}

extension CategoryTypeApi on CategoryType {
  String get apiValue => _format(_categoryTypes, this);
}
