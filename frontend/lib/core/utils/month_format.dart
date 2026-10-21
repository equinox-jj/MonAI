import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

DateTime monthOf(DateTime now) => DateTime(now.year, now.month);

abstract final class MonthFormat {
  static String monthName(DateTime month, String locale) =>
      DateFormat.LLLL(locale).format(month);

  static String monthYear(DateTime month, String locale) =>
      DateFormat.yMMMM(locale).format(month);

  static String shortMonthName(DateTime month, String locale) =>
      DateFormat.LLL(locale).format(month);

  static String dayMonth(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);

  static String dayMonthYear(DateTime date, String locale) =>
      DateFormat('d MMM y', locale).format(date);

  static String time(DateTime time) => DateFormat('HH:mm').format(time);
}

extension LocaleNameX on BuildContext {
  String get localeName => Localizations.localeOf(this).toLanguageTag();
}
