import 'package:flutter_test/flutter_test.dart';
import 'package:monai/features/reports/domain/logic/report_change.dart';

void main() {
  test('nothing to compare with gives no change', () {
    // Act
    final change = ReportChange.of(null);

    // Assert
    expect(change, isNull);
  });

  for (final (percent, trend, shown) in [
    (-10.4, ChangeTrend.less, 10),
    (11.6, ChangeTrend.more, 12),
    (0.4, ChangeTrend.same, 0),
    (-0.4, ChangeTrend.same, 0),
  ]) {
    test('$percent% reads as $trend $shown%', () {
      // Act
      final change = ReportChange.of(percent)!;

      // Assert
      expect(change.trend, trend);
      expect(change.percent, shown);
    });
  }
}
