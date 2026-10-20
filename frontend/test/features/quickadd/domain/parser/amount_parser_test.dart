import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/quickadd/domain/parser/amount_parser.dart';

List<int> _amounts(String text) =>
    AmountParser.findAll(text).map((m) => m.amount).toList();

void main() {
  group('AmountParser', () {
    test('reads rupiah suffixes', () {
      // Arrange
      const phrases = {
        'makan 35rb': 35000,
        'makan 35k': 35000,
        'makan 35 ribu': 35000,
        'gaji 2 juta': 2000000,
        'laptop 3jt': 3000000,
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _amounts(text)));

      // Assert
      phrases.forEach((text, amount) => expect(read[text], [amount]));
    });

    test('a dot or comma between groups of three is a thousands separator', () {
      // Arrange
      const phrases = {
        'parkir 1.500': 1500,
        'kopi 35.000': 35000,
        'sewa 2.500.000': 2500000,
        'kopi 35,000': 35000,
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _amounts(text)));

      // Assert
      phrases.forEach((text, amount) => expect(read[text], [amount]));
    });

    test('a decimal before a suffix scales', () {
      // Arrange
      const phrases = {
        'hp 1,5jt': 1500000,
        'hp 2.5 juta': 2500000,
        'roti 12,5rb': 12500,
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _amounts(text)));

      // Assert
      phrases.forEach((text, amount) => expect(read[text], [amount]));
    });

    test('reads the rp prefix as part of the amount', () {
      // Arrange
      const text = 'kopi rp 35.000';

      // Act
      final match = AmountParser.findAll(text).single;

      // Assert
      expect(match.amount, 35000);
      expect(text.substring(match.span.start, match.span.end), 'rp 35.000');
    });

    test('reads slang amounts', () {
      // Arrange
      const phrases = {
        'parkir gopek': 500,
        'permen seceng': 1000,
        'parkir goceng': 5000,
        'es teh ceban': 10000,
      };

      // Act
      final read = phrases.map((text, _) => MapEntry(text, _amounts(text)));

      // Assert
      phrases.forEach((text, amount) => expect(read[text], [amount]));
    });

    test('explicit amounts are confident and bare small numbers are not', () {
      // Act
      final suffixed = AmountParser.findAll('kopi 25rb').single;
      final plain = AmountParser.findAll('kopi 25000').single;
      final bare = AmountParser.findAll('kopi 25').single;

      // Assert
      expect(suffixed.confidence, greaterThanOrEqualTo(0.9));
      expect(plain.confidence, greaterThanOrEqualTo(0.7));
      expect(bare.confidence, lessThan(0.7));
    });

    test('finds every amount in order', () {
      // Act
      final amounts = _amounts('kopi 25rb sama parkir 5rb');

      // Assert
      expect(amounts, [25000, 5000]);
    });

    test('ignores numbers inside words and amounts past the limit', () {
      // Act
      final inWord = _amounts('beli h2o');
      final tooBig = _amounts('9999999999999');

      // Assert
      expect(inWord, isEmpty);
      expect(tooBig, isEmpty);
    });
  });
}
