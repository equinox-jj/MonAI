import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';

// Display text shared by the Settings sections.

extension AppThemeModeText on AppThemeMode {
  /// "System", "Light", "Dark".
  String label(AppLocalizations l10n) => switch (this) {
    .system => l10n.settingsThemeSystem,
    .light => l10n.settingsThemeLight,
    .dark => l10n.settingsThemeDark,
  };
}

extension AppLanguageText on AppLanguage {
  /// "Bahasa Indonesia" or "English"; [AppLanguage.system] reads as English,
  /// so pass the language the app is shown in.
  String label(AppLocalizations l10n) => switch (this) {
    .indonesian => l10n.settingsLanguageIndonesian,
    .english || .system => l10n.settingsLanguageEnglish,
  };
}
