import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/utils/monograms.dart';

void main() {
  group('initialsOf', () {
    test('takes the first letters of the first two words', () {
      // Arrange
      const name = '  joshua putra jeremia ';

      // Act
      final result = initialsOf(name);

      // Assert
      expect(result, 'JP');
    });

    test('is empty for a blank name', () {
      // Arrange
      const name = '   ';

      // Act
      final result = initialsOf(name);

      // Assert
      expect(result, isEmpty);
    });
  });

  group('walletMonogram', () {
    final cases = {
      'BCA Tabungan': 'BCA',
      'GoPay': 'GP',
      'Bank Jago': 'BJ',
      'Mandiri': 'MA',
      'Rp': 'RP',
      '': '',
    };
    for (final MapEntry(key: name, value: expected) in cases.entries) {
      test('gives "$expected" for "$name"', () {
        // Arrange
        final input = name;

        // Act
        final result = walletMonogram(input);

        // Assert
        expect(result, expected);
      });
    }
  });
}
