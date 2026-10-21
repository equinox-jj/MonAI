import 'package:flutter/widgets.dart';
import 'package:monai/core/model/app_language.dart';

extension AppLanguageX on AppLanguage {
  Locale? get locale => switch (tag) {
    final tag? => Locale(tag),
    null => null,
  };
}
