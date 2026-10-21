import 'package:drift/drift.dart';
import 'package:monai/core/data/database/converters.dart';
import 'package:monai/core/data/database/daos/daily_totals.dart';
import 'package:monai/core/data/database/daos/transaction_filter.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/core/data/database/tables/transaction_remote_keys_table.dart';
import 'package:monai/core/data/database/tables/transactions_table.dart';
import 'package:monai/core/model/transaction_type.dart';

part 'transaction_dao.g.dart';

/// Reads and writes the cached transactions and their paging keys.
///
/// Lists match the API's order: date, then id, both descending. Infinite
/// scroll watches a list with a growing `limit` instead of a paging source.
/// Write transactions only through the upserts here; see
/// `transactions_fts.drift`.
@DriftAccessor(
  tables: [Transactions, TransactionRemoteKeys],
  include: {'../tables/transactions_fts.drift'},
)
class TransactionDao extends DatabaseAccessor<MonAIDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.attachedDatabase);

  static const _date = DateOnlyConverter();

  // Binds ?1 to ?5 from [_filterVariables].
  static const _filterWhere = '''
date BETWEEN ?1 AND ?2
  AND (?3 IS NULL OR wallet_id = ?3 OR to_wallet_id = ?3)
  AND (?4 IS NULL OR category_id = ?4)
  AND (?5 IS NULL OR type = ?5)''';

  static const _listOrder = 'ORDER BY date DESC, id DESC';

  Stream<List<TransactionRow>> watchPage(
    TransactionFilter filter, {
    required int limit,
  }) => customSelect(
    'SELECT * FROM transactions WHERE $_filterWhere $_listOrder LIMIT ?6',
    variables: [..._filterVariables(filter), Variable.withInt(limit)],
    readsFrom: {transactions},
  ).watch().map(_rows);

  Stream<List<TransactionRow>> watchSearch(
    String match,
    TransactionFilter filter, {
    required int limit,
  }) => customSelect(
    '''
SELECT transactions.* FROM transactions
JOIN transactions_fts ON transactions.rowid = transactions_fts.rowid
WHERE transactions_fts MATCH ?6
  AND $_filterWhere
$_listOrder
LIMIT ?7''',
    variables: [
      ..._filterVariables(filter),
      Variable.withString(match),
      Variable.withInt(limit),
    ],
    readsFrom: {transactions, transactionsFts},
  ).watch().map(_rows);

  Stream<List<DailyNet>> watchDailyNets(TransactionFilter filter) =>
      customSelect(
        '''
SELECT date,
  SUM(CASE type WHEN ?6 THEN amount WHEN ?7 THEN -amount ELSE 0 END) AS net
FROM transactions
WHERE $_filterWhere
GROUP BY date''',
        variables: [
          ..._filterVariables(filter),
          Variable.withString(TransactionType.income.name),
          Variable.withString(TransactionType.expense.name),
        ],
        readsFrom: {transactions},
      ).watch().map(
        (rows) => rows
            .map(
              (row) => (
                date: _date.fromSql(row.read<String>('date')),
                net: row.read<int>('net'),
              ),
            )
            .toList(),
      );

  /// Expenses plus transfers out of [walletId]; transfers into it don't count.
  Stream<List<DailyAmount>> watchDailyOutflows(
    DateTime from,
    DateTime to,
    String walletId,
  ) =>
      customSelect(
        '''
SELECT date, SUM(amount) AS amount
FROM transactions
WHERE date BETWEEN ?1 AND ?2
  AND wallet_id = ?3
  AND type IN (?4, ?5)
GROUP BY date''',
        variables: [
          Variable.withString(_date.toSql(from)),
          Variable.withString(_date.toSql(to)),
          Variable.withString(walletId),
          Variable.withString(TransactionType.expense.name),
          Variable.withString(TransactionType.transfer.name),
        ],
        readsFrom: {transactions},
      ).watch().map(
        (rows) => rows
            .map(
              (row) => (
                date: _date.fromSql(row.read<String>('date')),
                amount: row.read<int>('amount'),
              ),
            )
            .toList(),
      );

  Stream<TransactionRow?> watch(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<TransactionRow>> watchRecent(
    DateTime from,
    DateTime to, {
    required int limit,
  }) => (_between(from, to)..limit(limit)).watch();

  Future<List<TransactionRow>> between(DateTime from, DateTime to) =>
      _between(from, to).get();

  /// The category of the newest [type] transaction whose note or merchant,
  /// trimmed and lowercased, is [text] (already lowercase). Newest by last
  /// edit, so a corrected category wins next time.
  Future<String?> latestCategoryForText(
    String text,
    TransactionType type,
  ) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.categoryId])
      ..where(
        transactions.type.equalsValue(type) &
            transactions.categoryId.isNotNull() &
            (transactions.note.trim().lower().equals(text) |
                transactions.merchant.trim().lower().equals(text)),
      )
      ..orderBy([OrderingTerm.desc(transactions.updatedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.read(transactions.categoryId);
  }

  Future<void> upsertAll(List<TransactionRow> rows) => batch(
    (b) => b.insertAllOnConflictUpdate(
      transactions,
      rows.map((row) => row.toCompanion(false)),
    ),
  );

  Future<void> deleteById(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<void> moveCategory(String from, String to) =>
      (update(transactions)..where((t) => t.categoryId.equals(from))).write(
        TransactionsCompanion(categoryId: Value(to)),
      );

  Future<void> deleteInRange(DateTime from, DateTime to) =>
      (delete(transactions)..where((t) => _dateBetween(t, from, to))).go();

  /// Drops rows dated up to [to] that sort at or before the ([date], [id])
  /// key in list order.
  Future<void> deleteFromKey(DateTime date, String id, DateTime to) {
    final key = _date.toSql(date);
    return (delete(transactions)..where(
          (t) =>
              t.date.isSmallerOrEqualValue(_date.toSql(to)) &
              (t.date.isBiggerThanValue(key) |
                  (t.date.equals(key) & t.id.isBiggerOrEqualValue(id))),
        ))
        .go();
  }

  Future<void> deleteMatching(TransactionFilter filter) => customUpdate(
    'DELETE FROM transactions WHERE $_filterWhere',
    variables: _filterVariables(filter),
    updates: {transactions},
    updateKind: UpdateKind.delete,
  );

  Future<TransactionRemoteKeyRow?> remoteKey(String queryKey) => (select(
    transactionRemoteKeys,
  )..where((t) => t.queryKey.equals(queryKey))).getSingleOrNull();

  Future<void> upsertRemoteKey(TransactionRemoteKeyRow key) =>
      into(transactionRemoteKeys)
          .insertOnConflictUpdate(key.toCompanion(false));

  /// In one transaction, so the list never shows a gap.
  Future<void> replaceQueryPage(
    TransactionFilter filter,
    List<TransactionRow> rows,
    TransactionRemoteKeyRow key,
  ) => transaction(() async {
    await deleteMatching(filter);
    await upsertAll(rows);
    await upsertRemoteKey(key);
  });

  Future<void> appendQueryPage(
    List<TransactionRow> rows,
    TransactionRemoteKeyRow key,
  ) => transaction(() async {
    await upsertAll(rows);
    await upsertRemoteKey(key);
  });

  /// Swaps in the first page of `GET /transactions` for the range. Only what
  /// the page covers is replaced: the whole range when [hasMore] is false,
  /// else from its oldest row up, so older rows cached by paging survive.
  Future<void> replaceRecent(
    DateTime from,
    DateTime to,
    List<TransactionRow> rows, {
    required bool hasMore,
  }) => transaction(() async {
    final oldest = rows.lastOrNull;
    if (!hasMore || oldest == null) {
      await deleteInRange(from, to);
    } else {
      await deleteFromKey(oldest.date, oldest.id, to);
    }
    await upsertAll(rows);
  });

  SimpleSelectStatement<$TransactionsTable, TransactionRow> _between(
    DateTime from,
    DateTime to,
  ) => select(transactions)
    ..where((t) => _dateBetween(t, from, to))
    ..orderBy([
      (t) => OrderingTerm.desc(t.date),
      (t) => OrderingTerm.desc(t.id),
    ]);

  Expression<bool> _dateBetween(
    $TransactionsTable t,
    DateTime from,
    DateTime to,
  ) => t.date.isBetweenValues(_date.toSql(from), _date.toSql(to));

  List<Variable<Object>> _filterVariables(TransactionFilter filter) => [
    Variable.withString(_date.toSql(filter.from)),
    Variable.withString(_date.toSql(filter.to)),
    Variable<String>(filter.walletId),
    Variable<String>(filter.categoryId),
    Variable<String>(filter.type?.name),
  ];

  List<TransactionRow> _rows(List<QueryRow> rows) =>
      rows.map((row) => transactions.map(row.data)).toList();
}
