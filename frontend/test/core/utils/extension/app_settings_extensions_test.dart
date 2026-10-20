import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/utils/extension/app_language_extension.dart';
import 'package:monai/core/utils/extension/app_theme_mode_extension.dart';

void main() {
  test('each theme pick maps to its ThemeMode', () {
    // Arrange
    const picks = AppThemeMode.values;

    // Act
    final modes = picks.map((pick) => pick.material).toList();

    // Assert
    expect(modes, [ThemeMode.system, ThemeMode.light, ThemeMode.dark]);
  });

  test('each language pick maps to its locale; system follows the device', () {
    // Arrange
    const picks = AppLanguage.values;

    // Act
    final locales = picks.map((pick) => pick.locale).toList();

    // Assert
    expect(locales, [null, const Locale('id'), const Locale('en')]);
  });
}
