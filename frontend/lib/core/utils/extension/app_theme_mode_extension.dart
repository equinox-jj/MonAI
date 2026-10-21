import 'package:flutter/material.dart';
import 'package:monai/core/model/app_theme_mode.dart';

extension AppThemeModeX on AppThemeMode {
  ThemeMode get material => switch (this) {
    .system => .system,
    .light => .light,
    .dark => .dark,
  };
}
