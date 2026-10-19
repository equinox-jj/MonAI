import 'package:drift/drift.dart';
import 'package:monai/core/database/converters.dart';
import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';

/// Cached transactions. No foreign keys to wallets or categories: each
/// endpoint fills the cache on its own, so a transaction can arrive before the
/// wallet it belongs to.
///
/// Keeps SQLite's implicit `rowid`, which `transactions_fts` indexes by.
@DataClassName('TransactionRow')
@TableIndex(name: 'index_transactions_date_id', columns: {#date, #id})
@TableIndex(name: 'index_transactions_wallet_id', columns: {#walletId})
@TableIndex(name: 'index_transactions_to_wallet_id', columns: {#toWalletId})
@TableIndex(name: 'index_transactions_category_id', columns: {#categoryId})
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => textEnum<TransactionType>()();

  /// Rupiah, always positive; [type] gives the direction.
  IntColumn get amount => integer()();
  TextColumn get walletId => text()();
  TextColumn get toWalletId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get date => text().map(const DateOnlyConverter())();
  TextColumn get note => text().nullable()();
  TextColumn get merchant => text().nullable()();
  TextColumn get receiptUrl => text().nullable()();
  TextColumn get source => textEnum<TransactionSource>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
