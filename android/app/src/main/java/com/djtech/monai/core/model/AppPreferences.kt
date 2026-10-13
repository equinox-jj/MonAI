package com.djtech.monai.core.model

/** Light or dark colors; [SYSTEM] follows the phone's dark mode setting. */
enum class ThemeMode { SYSTEM, LIGHT, DARK }

/** The app's language; [SYSTEM] follows the phone's language. */
enum class AppLanguage(val tag: String?) {
    SYSTEM(null),
    INDONESIAN("id"),
    ENGLISH("en"),
}
