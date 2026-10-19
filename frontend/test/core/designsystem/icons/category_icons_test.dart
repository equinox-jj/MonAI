import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/designsystem/icons/category_icons.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';

void main() {
  test('maps a known API icon name to its icon', () {
    // Arrange
    const name = 'restaurant';

    // Act
    final icon = categoryIcon(name);

    // Assert
    expect(icon, MonAIIcons.restaurant);
  });

  test('falls back to the generic category icon', () {
    // Arrange
    const names = [null, 'not_an_icon'];

    // Act
    final icons = names.map(categoryIcon);

    // Assert
    expect(icons, everyElement(MonAIIcons.category));
  });
}
