import 'package:flutter/foundation.dart';

/// What separates the columns of the CSV. Spreadsheets set to a locale
/// that writes decimals with a comma (Indonesian among them) expect a
/// semicolon.
enum CsvDelimiter {
  comma(','),
  semicolon(';');

  const CsvDelimiter(this.char);

  final String char;
}

/// Both included; each month is the first at local midnight.
@immutable
class ExportRange {
  const ExportRange(this.from, this.to);

  factory ExportRange.thisMonth(DateTime now) {
    final month = DateTime(now.year, now.month);
    return ExportRange(month, month);
  }

  static const maxMonths = 12;

  final DateTime from;
  final DateTime to;

  int get length => (to.year - from.year) * 12 + to.month - from.month + 1;

  List<DateTime> get months =>
      List.generate(length, (i) => DateTime(from.year, from.month + i));

  DateTime get lastDay => DateTime(to.year, to.month + 1, 0);

  bool isValidAt(DateTime now) =>
      !from.isAfter(to) &&
      length <= maxMonths &&
      !to.isAfter(DateTime(now.year, now.month));

  /// The range with [from] moved by [months]; [to] follows when the range
  /// would end before it starts or cover too many months. Never past
  /// [now]'s month.
  ExportRange movedFrom(int months, DateTime now) {
    final current = DateTime(now.year, now.month);
    var start = DateTime(from.year, from.month + months);
    if (start.isAfter(current)) start = current;
    var end = to;
    if (end.isBefore(start)) end = start;
    if (ExportRange(start, end).length > maxMonths) {
      end = DateTime(start.year, start.month + maxMonths - 1);
    }
    return ExportRange(start, end);
  }

  /// The range with [to] moved by [months]; [from] follows when the range
  /// would end before it starts or cover too many months. Never past
  /// [now]'s month.
  ExportRange movedTo(int months, DateTime now) {
    final current = DateTime(now.year, now.month);
    var end = DateTime(to.year, to.month + months);
    if (end.isAfter(current)) end = current;
    var start = from;
    if (start.isAfter(end)) start = end;
    if (ExportRange(start, end).length > maxMonths) {
      start = DateTime(end.year, end.month - maxMonths + 1);
    }
    return ExportRange(start, end);
  }

  @override
  bool operator ==(Object other) =>
      other is ExportRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'ExportRange($from, $to)';
}

@immutable
class ExportedCsv {
  const ExportedCsv({
    required this.path,
    required this.rowCount,
    required this.isComplete,
  });

  final String path;
  final int rowCount;

  /// False when the device was offline and only cached transactions were
  /// written.
  final bool isComplete;

  @override
  bool operator ==(Object other) =>
      other is ExportedCsv &&
      other.path == path &&
      other.rowCount == rowCount &&
      other.isComplete == isComplete;

  @override
  int get hashCode => Object.hash(path, rowCount, isComplete);
}
