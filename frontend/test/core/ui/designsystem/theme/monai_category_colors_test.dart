import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/theme/monai_category_colors.dart';

void main() {
  group('CategoryColors.parse', () {
    test('parses #RRGGBB as an opaque color', () {
      // Arrange
      const hex = '#F97316';

      // Act
      final color = CategoryColors.parse(hex);

      // Assert
      expect(color, const Color(0xFFF97316));
    });

    test('accepts hex without the leading #', () {
      // Arrange
      const hex = '0ea5e9';

      // Act
      final color = CategoryColors.parse(hex);

      // Assert
      expect(color, const Color(0xFF0EA5E9));
    });

    test('returns the fallback for null, wrong length and non-hex', () {
      // Arrange
      const inputs = [null, '', '#FFF', '#GGGGGG', '#F973160'];

      // Act
      final colors = inputs.map(CategoryColors.parse);

      // Assert
      expect(colors, everyElement(CategoryColors.fallback));
    });
  });

  group('CategoryColors.content', () {
    test('swaps a known color for its dark variant in dark mode', () {
      // Arrange
      const food = Color(0xFFF97316);

      // Act
      final dark = CategoryColors.content(food, dark: true);
      final light = CategoryColors.content(food, dark: false);

      // Assert
      expect(dark, const Color(0xFFFB923C));
      expect(light, food);
    });

    test('keeps an unknown color as-is in dark mode', () {
      // Arrange
      const custom = Color(0xFF123456);

      // Act
      final color = CategoryColors.content(custom, dark: true);

      // Assert
      expect(color, custom);
    });
  });

  group('WalletColor.fromHex', () {
    test('matches case-insensitively', () {
      // Arrange
      const hex = '#0891b2';

      // Act
      final color = WalletColor.fromHex(hex);

      // Assert
      expect(color, WalletColor.teal);
    });

    test('returns null for unknown or missing hex', () {
      // Arrange
      const inputs = [null, '#000000'];

      // Act
      final colors = inputs.map(WalletColor.fromHex);

      // Assert
      expect(colors, everyElement(isNull));
    });
  });
}
