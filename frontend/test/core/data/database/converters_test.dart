import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/data/database/converters.dart';

void main() {
  group('DateOnlyConverter', () {
    const converter = DateOnlyConverter();

    test('writes a zero-padded ISO date and drops the time', () {
      // Arrange
      final value = DateTime(2026, 3, 7, 18, 30);

      // Act
      final result = converter.toSql(value);

      // Assert
      expect(result, '2026-03-07');
    });

    test('reads an ISO date as local midnight', () {
      // Arrange
      const value = '2026-03-07';

      // Act
      final result = converter.fromSql(value);

      // Assert
      expect(result, DateTime(2026, 3, 7));
    });
  });

  group('YearMonthConverter', () {
    const converter = YearMonthConverter();

    test('writes a zero-padded year and month', () {
      // Arrange
      final value = DateTime(2026, 3, 15);

      // Act
      final result = converter.toSql(value);

      // Assert
      expect(result, '2026-03');
    });

    test('reads the first day of the month', () {
      // Arrange
      const value = '2026-03';

      // Act
      final result = converter.fromSql(value);

      // Assert
      expect(result, DateTime(2026, 3));
    });
  });

  group('StringListConverter', () {
    const converter = StringListConverter();

    test('round-trips a list through JSON', () {
      // Arrange
      const value = ['a', 'b "quoted"'];

      // Act
      final result = converter.fromSql(converter.toSql(value));

      // Assert
      expect(result, value);
    });
  });
}
