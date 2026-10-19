import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/designsystem/components/monai_width_class.dart';

void main() {
  test('classifies widths at the 600 and 840 breakpoints', () {
    // Arrange
    const widths = [0.0, 599.9, 600.0, 839.9, 840.0, 1280.0];

    // Act
    final classes = widths.map(MonAIWidthClass.of).toList();

    // Assert
    expect(classes, [
      MonAIWidthClass.compact,
      MonAIWidthClass.compact,
      MonAIWidthClass.medium,
      MonAIWidthClass.medium,
      MonAIWidthClass.expanded,
      MonAIWidthClass.expanded,
    ]);
  });
}
