import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/export/domain/entity/csv_export.dart';

final _now = DateTime(2026, 10, 21);
final _october = DateTime(2026, 10);

void main() {
  group('ExportRange', () {
    test('starts on the current month alone', () {
      // Act
      final range = ExportRange.thisMonth(_now);

      // Assert
      expect(range, ExportRange(_october, _october));
      expect(range.length, 1);
      expect(range.lastDay, DateTime(2026, 10, 31));
    });

    test('lists its months oldest first, across a year', () {
      // Arrange
      final range = ExportRange(DateTime(2025, 11), DateTime(2026, 2));

      // Act
      final months = range.months;

      // Assert
      expect(months, [
        DateTime(2025, 11),
        DateTime(2025, 12),
        DateTime(2026),
        DateTime(2026, 2),
      ]);
    });

    test('moving From back keeps To', () {
      // Act
      final range = ExportRange.thisMonth(_now).movedFrom(-2, _now);

      // Assert
      expect(range, ExportRange(DateTime(2026, 8), _october));
    });

    test('moving From past To pulls To along, never past now', () {
      // Arrange
      final range = ExportRange(DateTime(2026, 8), DateTime(2026, 8));

      // Act
      final moved = range.movedFrom(1, _now).movedFrom(5, _now);

      // Assert
      expect(moved, ExportRange(_october, _october));
    });

    test('a range never covers more than 12 months', () {
      // Arrange
      final range = ExportRange(DateTime(2025, 11), _october);

      // Act
      final wider = range.movedFrom(-1, _now);
      final narrowerEnd = ExportRange(
        DateTime(2025, 11),
        DateTime(2026, 9),
      ).movedTo(1, _now);

      // Assert
      expect(wider, ExportRange(DateTime(2025, 10), DateTime(2026, 9)));
      expect(narrowerEnd.length, ExportRange.maxMonths);
    });

    test('moving To before From pulls From along', () {
      // Arrange
      final range = ExportRange(DateTime(2026, 9), _october);

      // Act
      final moved = range.movedTo(-3, _now);

      // Assert
      expect(moved, ExportRange(DateTime(2026, 7), DateTime(2026, 7)));
    });

    test('is valid only up to this month and 12 months', () {
      // Assert
      expect(ExportRange(_october, _october).isValidAt(_now), isTrue);
      expect(
        ExportRange(DateTime(2026, 11), DateTime(2026, 11)).isValidAt(_now),
        isFalse,
      );
      expect(
        ExportRange(DateTime(2025, 10), _october).isValidAt(_now),
        isFalse,
      );
    });
  });
}
