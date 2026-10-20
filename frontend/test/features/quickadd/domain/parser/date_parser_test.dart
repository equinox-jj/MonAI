import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/quickadd/domain/parser/date_parser.dart';

// Saturday 10 October 2026.
final _today = DateTime(2026, 10, 10);

DateTime? _date(String text) => DateParser.find(text, _today)?.date;

void main() {
  group('DateParser', () {
    test('reads today and yesterday in both languages', () {
      // Arrange
      final phrases = {
        'kopi hari ini': _today,
        'tadi pagi sarapan': _today,
        'lunch today': _today,
        'makan kemarin': DateTime(2026, 10, 9),
        'makan kmrn': DateTime(2026, 10, 9),
        'dinner yesterday': DateTime(2026, 10, 9),
        'kemarin lusa': DateTime(2026, 10, 8),
        '3 hari lalu': DateTime(2026, 10, 7),
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _date(text)));

      // Assert
      phrases.forEach((text, date) => expect(read[text], date, reason: text));
    });

    test('a weekday means the latest one, before today when it says last', () {
      // Arrange
      final phrases = {
        'bensin senin lalu': DateTime(2026, 10, 5),
        'nonton jumat': DateTime(2026, 10, 9),
        'fuel last monday': DateTime(2026, 10, 5),
        'sabtu lalu': DateTime(2026, 10, 3),
        'sabtu': _today,
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _date(text)));

      // Assert
      phrases.forEach((text, date) => expect(read[text], date, reason: text));
    });

    test('a day of the month is the latest one not in the future', () {
      // Arrange
      final phrases = {
        'listrik tgl 5': DateTime(2026, 10, 5),
        'sewa tanggal 25': DateTime(2026, 9, 25),
        'bayar 3/9': DateTime(2026, 9, 3),
        '17 agustus': DateTime(2026, 8, 17),
        '24 des': DateTime(2025, 12, 24),
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _date(text)));

      // Assert
      phrases.forEach((text, date) => expect(read[text], date, reason: text));
    });

    test('reports the matched characters', () {
      // Arrange
      const text = 'makan siang kemarin';

      // Act
      final match = DateParser.find(text, _today)!;

      // Assert
      expect(text.substring(match.span.start, match.span.end), 'kemarin');
    });

    test('no date words means no match', () {
      // Act
      final none = _date('makan siang 35rb');
      final invalid = _date('tgl 31 feb');

      // Assert
      expect(none, isNull);
      expect(invalid, isNull);
    });
  });
}
