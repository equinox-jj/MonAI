import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';

void main() {
  test('every icon has an SVG asset', () {
    // Arrange
    const icons = MonAIIcons.all;

    // Act
    final missing = icons
        .where((icon) => !File(icon.assetPath).existsSync())
        .map((icon) => icon.name);

    // Assert
    expect(missing, isEmpty);
  });

  test('every SVG asset is listed in MonAIIcons.all', () {
    // Arrange
    final listed = MonAIIcons.all.map((icon) => icon.assetPath).toSet();

    // Act
    final unlisted = Directory('assets/icons')
        .listSync()
        .map((file) => file.path)
        .where((path) => path.endsWith('.svg') && !listed.contains(path));

    // Assert
    expect(unlisted, isEmpty);
  });
}
