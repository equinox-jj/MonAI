import 'dart:convert';

import 'package:drift/drift.dart';

/// ISO `yyyy-MM-dd` text, so `ORDER BY` and `BETWEEN` work on the column.
/// Reads back as local midnight; the time of day is dropped on write.
class DateOnlyConverter extends TypeConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) =>
      '${_year(value)}-${_two(value.month)}-${_two(value.day)}';
}

/// ISO `yyyy-MM` text; reads back as the first of the month at local midnight.
class YearMonthConverter extends TypeConverter<DateTime, String> {
  const YearMonthConverter();

  @override
  DateTime fromSql(String fromDb) {
    final [year, month] = fromDb.split('-');
    return DateTime(int.parse(year), int.parse(month));
  }

  @override
  String toSql(DateTime value) => '${_year(value)}-${_two(value.month)}';
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

String _year(DateTime value) => value.year.toString().padLeft(4, '0');

String _two(int value) => value.toString().padLeft(2, '0');
