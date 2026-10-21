import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/components/monai_feedback.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';

import '../../../../helpers/pump_themed.dart';

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

  testWidgets('dialog buttons too long for one row stack instead', (
    tester,
  ) async {
    // Arrange
    await pumpThemed(
      tester,
      MonAIAlertDialog(
        title: 'Sign out of all devices?',
        message: 'Every device will need to sign in again.',
        confirmLabel: 'Sign out of all devices',
        dismissLabel: 'Cancel',
        onConfirm: () {},
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(tester.takeException(), isNull);
    final confirm = tester.getTopLeft(find.text('Sign out of all devices'));
    final cancel = tester.getTopLeft(find.text('Cancel'));
    expect(confirm.dy, lessThan(cancel.dy));
  });
}
