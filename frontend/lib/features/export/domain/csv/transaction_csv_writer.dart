import 'package:monai/core/model/transaction_source.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';
import 'package:monai/features/shared/domain/entity/transaction.dart';

/// Writes transactions as a CSV that spreadsheets open as-is: UTF-8 with a
/// byte order mark (so Excel reads Indonesian text right), CRLF line ends
/// and RFC 4180 quoting. Rows run oldest first.
abstract final class TransactionCsvWriter {
  static const byteOrderMark = '﻿';
  static const _lineEnd = '\r\n';

  static const header = [
    'Date',
    'Type',
    'Amount',
    'Wallet',
    'To wallet',
    'Category',
    'Merchant',
    'Note',
    'Source',
  ];

  // A cell starting with one of these runs as a formula in a spreadsheet.
  static final _formulaStart = RegExp(r'^[=+\-@\t\r]');

  /// The CSV of [transactions], naming wallets and categories by
  /// [walletNames] and [categoryNames] (an unknown id is left blank).
  static String write(
    List<Transaction> transactions, {
    required Map<String, String> walletNames,
    required Map<String, String> categoryNames,
    CsvDelimiter delimiter = CsvDelimiter.comma,
  }) {
    final sorted = [...transactions]..sort(_oldestFirst);
    final buffer = StringBuffer(byteOrderMark)
      ..write(_line(header, delimiter, guard: false));
    for (final t in sorted) {
      buffer.write(
        _line([
          _date(t.date),
          _type(t.type),
          '${t.amount}',
          walletNames[t.walletId] ?? '',
          walletNames[t.toWalletId] ?? '',
          categoryNames[t.categoryId] ?? '',
          t.merchant ?? '',
          t.note ?? '',
          _source(t.source),
        ], delimiter),
      );
    }
    return buffer.toString();
  }

  static int _oldestFirst(Transaction a, Transaction b) {
    final byDate = a.date.compareTo(b.date);
    if (byDate != 0) return byDate;
    final byCreated = a.createdAt.compareTo(b.createdAt);
    return byCreated != 0 ? byCreated : a.id.compareTo(b.id);
  }

  static String _line(
    List<String> cells,
    CsvDelimiter delimiter, {
    bool guard = true,
  }) =>
      cells.map((c) => _cell(c, delimiter, guard: guard)).join(delimiter.char) +
      _lineEnd;

  /// [value] quoted when it holds the delimiter, a quote or a line break,
  /// with inner quotes doubled; user text that would run as a formula is
  /// prefixed with an apostrophe.
  static String _cell(
    String value,
    CsvDelimiter delimiter, {
    required bool guard,
  }) {
    final safe = guard && _formulaStart.hasMatch(value) ? "'$value" : value;
    final needsQuotes =
        safe.contains(delimiter.char) ||
        safe.contains('"') ||
        safe.contains('\n') ||
        safe.contains('\r');
    return needsQuotes ? '"${safe.replaceAll('"', '""')}"' : safe;
  }

  static String _date(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static String _type(TransactionType type) => switch (type) {
    TransactionType.expense => 'EXPENSE',
    TransactionType.income => 'INCOME',
    TransactionType.transfer => 'TRANSFER',
  };

  static String _source(TransactionSource source) => switch (source) {
    TransactionSource.manual => 'MANUAL',
    TransactionSource.quickAdd => 'QUICK_ADD',
    TransactionSource.receipt => 'RECEIPT',
  };
}
