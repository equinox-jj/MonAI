import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/designsystem/components/monai_text_field.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  testWidgets('shows the label and supporting text', (tester) async {
    // Arrange
    const field = MonAITextField(
      label: 'Email',
      supportingText: 'This email is already registered.',
      tone: MonAIFieldTone.error,
    );

    // Act
    await pumpThemed(tester, const SizedBox(width: 320, child: field));

    // Assert
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('This email is already registered.'), findsOneWidget);
  });

  testWidgets('reports edits through onChanged', (tester) async {
    // Arrange
    String? value;
    await pumpThemed(
      tester,
      SizedBox(width: 320, child: MonAITextField(onChanged: (v) => value = v)),
    );

    // Act
    await tester.enterText(find.byType(TextField), 'kopi');

    // Assert
    expect(value, 'kopi');
  });

  testWidgets('password field toggles visibility', (tester) async {
    // Arrange
    await pumpThemed(
      tester,
      const SizedBox(
        width: 320,
        child: MonAIPasswordField(
          showPasswordLabel: 'Show password',
          hidePasswordLabel: 'Hide password',
        ),
      ),
    );
    bool obscured() =>
        tester.widget<TextField>(find.byType(TextField)).obscureText;
    final initiallyObscured = obscured();

    // Act
    await tester.tap(find.bySemanticsLabel('Show password'));
    await tester.pump();

    // Assert
    expect(initiallyObscured, isTrue);
    expect(obscured(), isFalse);
    expect(find.bySemanticsLabel('Hide password'), findsOneWidget);
  });

  testWidgets('search field clears its text', (tester) async {
    // Arrange
    final changes = <String>[];
    await pumpThemed(
      tester,
      SizedBox(
        width: 320,
        child: MonAISearchField(
          placeholder: 'Search',
          clearLabel: 'Clear search',
          onChanged: changes.add,
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'parkir');
    await tester.pump();

    // Act
    await tester.tap(find.bySemanticsLabel('Clear search'));
    await tester.pump();

    // Assert
    expect(changes, ['parkir', '']);
    expect(find.bySemanticsLabel('Clear search'), findsNothing);
  });
}
