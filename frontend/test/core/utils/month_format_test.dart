import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monai/core/utils/month_format.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  test('names months in the locale', () {
    // Arrange
    final month = DateTime(2026, 10);

    // Act
    final english = MonthFormat.monthName(month, 'en');
    final indonesian = MonthFormat.monthName(month, 'id');

    // Assert
    expect(english, 'October');
    expect(indonesian, 'Oktober');
  });

  test('shortens months and days', () {
    // Arrange
    final date = DateTime(2026, 10, 7, 9, 5);

    // Act
    final short = MonthFormat.shortMonthName(date, 'en');
    final dayMonth = MonthFormat.dayMonth(date, 'en');
    final time = MonthFormat.time(date);

    // Assert
    expect(short, 'Oct');
    expect(dayMonth, '7 Oct');
    expect(time, '09:05');
  });
}
