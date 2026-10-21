import 'package:monai/features/quickadd/domain/parser/text_span.dart';

class DateMatch {
  const DateMatch(this.date, this.span, this.confidence);

  /// Local midnight.
  final DateTime date;
  final TextSpan span;
  final double confidence;
}

typedef _Resolve = (DateTime, double)? Function(RegExpMatch, DateTime today);

/// Finds relative and partial dates (`kemarin`, `senin lalu`, `tgl 5`),
/// never later than today.
abstract final class DateParser {
  static const _sure = 0.95;
  static const _likely = 0.85;

  static const _weekdays = {
    'senin': DateTime.monday,
    'selasa': DateTime.tuesday,
    'rabu': DateTime.wednesday,
    'kamis': DateTime.thursday,
    'jumat': DateTime.friday,
    "jum'at": DateTime.friday,
    'sabtu': DateTime.saturday,
    'minggu': DateTime.sunday,
    'ahad': DateTime.sunday,
    'monday': DateTime.monday,
    'tuesday': DateTime.tuesday,
    'wednesday': DateTime.wednesday,
    'thursday': DateTime.thursday,
    'friday': DateTime.friday,
    'saturday': DateTime.saturday,
    'sunday': DateTime.sunday,
  };

  static const _months = [
    ['jan', 'januari', 'january'],
    ['feb', 'februari', 'february'],
    ['mar', 'maret', 'march'],
    ['apr', 'april'],
    ['mei', 'may'],
    ['jun', 'juni', 'june'],
    ['jul', 'juli', 'july'],
    ['agu', 'agt', 'agustus', 'aug', 'august'],
    ['sep', 'sept', 'september'],
    ['okt', 'oktober', 'oct', 'october'],
    ['nov', 'november'],
    ['des', 'desember', 'dec', 'december'],
  ];

  static final Map<String, int> _monthNumbers = {
    for (final (index, names) in _months.indexed)
      for (final name in names) name: index + 1,
  };

  static final _weekdayNames = _weekdays.keys.join('|');
  static final _monthNames =
      (_monthNumbers.keys.toList()
            ..sort((a, b) => b.length.compareTo(a.length)))
          .join('|');

  /// Tried in order; the first that yields a valid date wins.
  static final List<(RegExp, _Resolve)> _rules = [
    (
      _word('kemarin lusa|kmrn lusa'),
      (_, today) => (_minusDays(today, 2), _sure),
    ),
    (
      _word(
        'hari ini|today|barusan|tadi(?: pagi| siang| sore| malam)?'
        '|(?:pagi|siang|sore|malam) ini|tonight',
      ),
      (_, today) => (today, _sure),
    ),
    (
      _word('kemarin|kemaren|kmrn|kmarin|yesterday|semalam'),
      (_, today) => (_minusDays(today, 1), _sure),
    ),
    (
      _word(r'(\d{1,2}) (?:hari|hr) (?:yang |yg )?lalu|(\d{1,2}) days? ago'),
      (match, today) {
        final days = int.parse(match.group(1) ?? match.group(2)!);
        return (_minusDays(today, days), _sure);
      },
    ),
    (
      _word(
        '(?:hari )?($_weekdayNames)(?: (lalu|kemarin|kmrn))?'
        '|(last) ($_weekdayNames)',
      ),
      (match, today) {
        final day = _weekdays[match.group(1) ?? match.group(4)]!;
        final beforeToday = match.group(2) != null || match.group(3) != null;
        return (_previous(today, day, orSame: !beforeToday), _likely);
      },
    ),
    (
      _word(r'(\d{1,2}) (' + _monthNames + r')(?: (\d{4}))?'),
      (match, today) => _sureOrNull(
        _dayOfMonth(
          today,
          int.parse(match.group(1)!),
          _monthNumbers[match.group(2)],
          int.tryParse(match.group(3) ?? ''),
        ),
      ),
    ),
    (
      _word(r'(?:tgl|tanggal|tg)\.? ?(\d{1,2})(?:[/-](\d{1,2}))?'),
      (match, today) => _sureOrNull(
        _dayOfMonth(
          today,
          int.parse(match.group(1)!),
          int.tryParse(match.group(2) ?? ''),
          null,
        ),
      ),
    ),
    (
      _word(r'(\d{1,2})/(\d{1,2})(?:/(\d{4}))?'),
      (match, today) {
        final date = _dayOfMonth(
          today,
          int.parse(match.group(1)!),
          int.parse(match.group(2)!),
          int.tryParse(match.group(3) ?? ''),
        );
        return date == null ? null : (date, _likely);
      },
    ),
  ];

  static DateMatch? find(String text, DateTime today) {
    for (final (regex, resolve) in _rules) {
      for (final match in regex.allMatches(text)) {
        final resolved = resolve(match, today);
        if (resolved == null) continue;
        final (date, confidence) = resolved;
        if (!date.isAfter(today)) {
          return DateMatch(date, TextSpan(match.start, match.end), confidence);
        }
      }
    }
    return null;
  }

  static (DateTime, double)? _sureOrNull(DateTime? date) =>
      date == null ? null : (date, _sure);

  static DateTime _minusDays(DateTime today, int days) =>
      DateTime(today.year, today.month, today.day - days);

  /// The last [weekday] before [today], or on it when [orSame].
  static DateTime _previous(
    DateTime today,
    int weekday, {
    required bool orSame,
  }) {
    var back = (today.weekday - weekday) % 7;
    if (back == 0 && !orSame) back = 7;
    return _minusDays(today, back);
  }

  /// The latest [day] not after [today]: in [month] (this year, else last
  /// year) when given, otherwise this month or the one before. Null for a
  /// day the month doesn't have.
  static DateTime? _dayOfMonth(DateTime today, int day, int? month, int? year) {
    if (month != null && (month < 1 || month > 12)) return null;
    final (int y, int m) = switch (month) {
      null when day <= today.day => (today.year, today.month),
      null => _previousMonth(today.year, today.month),
      final m when year != null => (year, m),
      final m when m > today.month => (today.year - 1, m),
      final m => (today.year, m),
    };
    if (day < 1 || day > DateTime(y, m + 1, 0).day) return null;
    final date = DateTime(y, m, day);
    // "24 des" said in October means last December.
    if (date.isAfter(today) && month != null && year == null) {
      return DateTime(y - 1, m, day);
    }
    return date;
  }

  static (int, int) _previousMonth(int year, int month) =>
      month == 1 ? (year - 1, 12) : (year, month - 1);

  static RegExp _word(String pattern) => wordPattern(pattern, extra: "'");
}
