import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/components/monai_fade_through_stack.dart';

void main() {
  Widget stack(int index, {bool disableAnimations = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Directionality(
      textDirection: .ltr,
      child: MonAIFadeThroughStack(
        index: index,
        children: const [Text('first'), Text('second')],
      ),
    ),
  );

  double opacity(WidgetTester tester) =>
      tester.widget<FadeTransition>(find.byType(FadeTransition)).opacity.value;

  testWidgets('shows the first child fully opaque', (tester) async {
    // Arrange
    await tester.pumpWidget(stack(0));

    // Act
    final value = opacity(tester);

    // Assert
    expect(value, 1);
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);
  });

  testWidgets('fades the newly selected child in', (tester) async {
    // Arrange
    await tester.pumpWidget(stack(0));

    // Act
    await tester.pumpWidget(stack(1));
    await tester.pump(const Duration(milliseconds: 50));
    final midway = opacity(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(midway, inExclusiveRange(0, 1));
    expect(opacity(tester), 1);
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
  });

  testWidgets('switches at once when animations are disabled', (tester) async {
    // Arrange
    await tester.pumpWidget(stack(0, disableAnimations: true));

    // Act
    await tester.pumpWidget(stack(1, disableAnimations: true));

    // Assert
    expect(opacity(tester), 1);
  });

  testWidgets('keeps hidden children mounted', (tester) async {
    // Arrange
    await tester.pumpWidget(stack(0));

    // Act
    await tester.pumpWidget(stack(1));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('first', skipOffstage: false), findsOneWidget);
  });
}
