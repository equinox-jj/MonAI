import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// The first of [now]'s month.
DateTime monthOf(DateTime now) => DateTime(now.year, now.month);

/// Month and day names in a locale such as `id` or `en`.
abstract final class MonthFormat {
  /// `October`.
  static String monthName(DateTime month, String locale) =>
      DateFormat.LLLL(locale).format(month);

  /// `Oct`.
  static String shortMonthName(DateTime month, String locale) =>
      DateFormat.LLL(locale).format(month);

  /// `20 Oct`.
  static String dayMonth(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);

  /// `12:40`.
  static String time(DateTime time) => DateFormat('HH:mm').format(time);
}

/// The app's current locale for [MonthFormat].
extension LocaleNameX on BuildContext {
  /// The locale tag of the nearest [Localizations], e.g. `id`.
  String get localeName => Localizations.localeOf(this).toLanguageTag();
}
