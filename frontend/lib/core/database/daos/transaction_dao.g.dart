// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<MonAIDatabase> {
  $TransactionsTable get transactions => attachedDatabase.transactions;
  TransactionsFts get transactionsFts => attachedDatabase.transactionsFts;
  $TransactionRemoteKeysTable get transactionRemoteKeys =>
      attachedDatabase.transactionRemoteKeys;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $TransactionsFtsTableManager get transactionsFts =>
      $TransactionsFtsTableManager(_db.attachedDatabase, _db.transactionsFts);
  $$TransactionRemoteKeysTableTableManager get transactionRemoteKeys =>
      $$TransactionRemoteKeysTableTableManager(
        _db.attachedDatabase,
        _db.transactionRemoteKeys,
      );
}
