import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/utils/money_format.dart';

void main() {
  group('formatRupiah', () {
    test('groups thousands with dots', () {
      // Arrange
      const amount = 8250000;

      // Act
      final result = formatRupiah(amount);

      // Assert
      expect(result, 'Rp 8.250.000');
    });

    test('formats zero', () {
      // Arrange
      const amount = 0;

      // Act
      final result = formatRupiah(amount);

      // Assert
      expect(result, 'Rp 0');
    });

    test('puts a minus sign before negative amounts', () {
      // Arrange
      const amount = -35000;

      // Act
      final result = formatRupiah(amount);

      // Assert
      expect(result, '−Rp 35.000');
    });
  });

  group('formatRupiahSigned', () {
    test('adds a minus sign when negative', () {
      // Arrange
      const amount = 35000;

      // Act
      final result = formatRupiahSigned(amount, negative: true);

      // Assert
      expect(result, '−Rp 35.000');
    });

    test('adds a plus sign when positive, ignoring the input sign', () {
      // Arrange
      const amount = -35000;

      // Act
      final result = formatRupiahSigned(amount, negative: false);

      // Assert
      expect(result, '+Rp 35.000');
    });
  });

  group('formatRupiahCompact', () {
    final cases = {
      999: 'Rp 999',
      35000: 'Rp 35 rb',
      2415000: 'Rp 2,4 jt',
      999999: 'Rp 999,9 rb',
      2000000000: 'Rp 2 M',
      -1500000: '−Rp 1,5 jt',
    };
    for (final MapEntry(key: amount, value: expected) in cases.entries) {
      test('formats $amount as $expected', () {
        // Arrange
        final input = amount;

        // Act
        final result = formatRupiahCompact(input);

        // Assert
        expect(result, expected);
      });
    }
  });
}
