import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/designsystem/components/monai_feedback.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';

void main() {
  testWidgets('alert dialog opens and its confirm button fires', (
    tester,
  ) async {
    // Arrange
    final semantics = tester.ensureSemantics();
    var confirmed = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: MonAITheme.light(),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => MonAIAlertDialog(
                title: 'Delete wallet?',
                message: 'Its transactions will be deleted too.',
                confirmLabel: 'Delete',
                dismissLabel: 'Cancel',
                onConfirm: () => confirmed++,
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));

    // Assert
    expect(tester.takeException(), isNull);
    expect(find.text('Delete wallet?'), findsOneWidget);
    expect(confirmed, 1);
    semantics.dispose();
  });
}
