import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/components/monai_selection.dart';

import '../../../../helpers/pump_themed.dart';

void main() {
  testWidgets('segmented control reports the tapped segment', (tester) async {
    // Arrange
    String? picked;
    await pumpThemed(
      tester,
      SizedBox(
        width: 320,
        child: MonAISegmentedControl<String>(
          segments: const [
            MonAISegment(value: 'expense', label: 'Expense'),
            MonAISegment(value: 'income', label: 'Income'),
          ],
          selected: 'expense',
          onChanged: (v) => picked = v,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Income'));

    // Assert
    expect(picked, 'income');
  });
}
