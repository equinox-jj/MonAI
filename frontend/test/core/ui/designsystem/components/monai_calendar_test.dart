import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/components/monai_calendar.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';

import '../../../../helpers/pump_themed.dart';

void main() {
  final today = DateTime(2026, 10, 20);

  Future<void> pumpCalendar(
    WidgetTester tester, {
    DateTime? shownMonth,
    ValueChanged<DateTime>? onSelect,
    ValueChanged<DateTime>? onShowMonth,
  }) => pumpThemed(
    tester,
    SizedBox(
      width: 360,
      child: MonAICalendar(
        selected: today,
        shownMonth: shownMonth ?? DateTime(2026, 10),
        today: today,
        onSelect: onSelect ?? (_) {},
        onShowMonth: onShowMonth ?? (_) {},
        dayUnavailableLabel: (date) => '$date, unavailable',
      ),
    ),
  );

  testWidgets('draws only the weeks the month needs', (tester) async {
    // Arrange
    await pumpCalendar(tester);

    // Act
    final grid = tester.getSize(find.byKey(MonAICalendar.daysKey));

    // Assert
    // October 2026 starts on a Thursday: 4 blanks + 31 days = 5 weeks.
    expect(grid.height, 5 * MonAISizes.touchTarget);
    expect(find.text('31'), findsOneWidget);
  });

  testWidgets('puts the first day under its weekday', (tester) async {
    // Arrange
    await pumpCalendar(tester);

    // Act
    final thursday = tester.getCenter(find.text('T').at(1));
    final first = tester.getCenter(find.text('1'));

    // Assert
    expect(first.dx, moreOrLessEquals(thursday.dx));
  });

  testWidgets('reports a tapped past day', (tester) async {
    // Arrange
    DateTime? picked;
    await pumpCalendar(tester, onSelect: (d) => picked = d);

    // Act
    await tester.tap(find.text('14'));

    // Assert
    expect(picked, DateTime(2026, 10, 14));
  });

  testWidgets('ignores taps on future days', (tester) async {
    // Arrange
    DateTime? picked;
    await pumpCalendar(tester, onSelect: (d) => picked = d);

    // Act
    await tester.tap(find.text('21'));

    // Assert
    expect(picked, isNull);
  });

  testWidgets('pages to the previous month', (tester) async {
    // Arrange
    DateTime? shown;
    await pumpCalendar(tester, onShowMonth: (m) => shown = m);

    // Act
    await tester.tap(find.byTooltip('September 2026'));

    // Assert
    expect(shown, DateTime(2026, 9));
  });

  testWidgets('cannot page past the current month', (tester) async {
    // Arrange
    DateTime? shown;
    await pumpCalendar(tester, onShowMonth: (m) => shown = m);

    // Act
    await tester.tap(find.byTooltip('November 2026'));

    // Assert
    expect(shown, isNull);
  });

  testWidgets('can page forward from an earlier month', (tester) async {
    // Arrange
    DateTime? shown;
    await pumpCalendar(
      tester,
      shownMonth: DateTime(2026, 9),
      onShowMonth: (m) => shown = m,
    );

    // Act
    await tester.tap(find.byTooltip('October 2026'));

    // Assert
    expect(shown, DateTime(2026, 10));
  });
}
