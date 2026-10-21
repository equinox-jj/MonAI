import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/components/monai_button.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';

import '../../../../helpers/pump_themed.dart';

void main() {
  testWidgets('calls onPressed when tapped', (tester) async {
    // Arrange
    var taps = 0;
    await pumpThemed(
      tester,
      MonAIButton(label: 'Save', onPressed: () => taps++),
    );

    // Act
    await tester.tap(find.text('Save'));

    // Assert
    expect(taps, 1);
  });

  testWidgets('ignores taps while loading and shows a spinner', (tester) async {
    // Arrange
    var taps = 0;
    await pumpThemed(
      tester,
      MonAIButton(label: 'Save', onPressed: () => taps++, loading: true),
    );

    // Act
    await tester.tap(find.text('Save'));

    // Assert
    expect(taps, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('reports disabled to semantics without onPressed', (
    tester,
  ) async {
    // Arrange
    final handle = tester.ensureSemantics();

    // Act
    await pumpThemed(tester, const MonAIButton(label: 'Save', onPressed: null));

    // Assert
    expect(
      tester.getSemantics(find.text('Save')),
      matchesSemantics(label: 'Save', isButton: true, hasEnabledState: true),
    );
    handle.dispose();
  });

  testWidgets('MonAIIconButton exposes its tooltip as the label', (
    tester,
  ) async {
    // Arrange
    var taps = 0;
    await pumpThemed(
      tester,
      MonAIIconButton(
        icon: MonAIIcons.search,
        tooltip: 'Search',
        onPressed: () => taps++,
      ),
    );

    // Act
    await tester.tap(find.bySemanticsLabel('Search'));

    // Assert
    expect(taps, 1);
  });
}
