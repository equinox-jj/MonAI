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
}
