package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.locale.languageOf
import com.djtech.monai.core.model.AppLanguage
import com.djtech.monai.core.model.ThemeMode

@Composable
@ReadOnlyComposable
internal fun ThemeMode.label(): String = stringResource(
    when (this) {
        ThemeMode.SYSTEM -> R.string.settings_theme_system
        ThemeMode.LIGHT -> R.string.settings_theme_light
        ThemeMode.DARK -> R.string.settings_theme_dark
    },
)

/**
 * The language the screen is shown in. Following the phone resolves to the phone's language, and
 * to English (the untranslated default) when that isn't Indonesian.
 */
@Composable
@ReadOnlyComposable
internal fun AppLanguage.effective(): AppLanguage {
    if (this != AppLanguage.SYSTEM) return this
    val phone = languageOf(LocalConfiguration.current.locales[0]?.language)
    return if (phone == AppLanguage.INDONESIAN) AppLanguage.INDONESIAN else AppLanguage.ENGLISH
}

@Composable
@ReadOnlyComposable
internal fun AppLanguage.label(): String = stringResource(
    if (effective() == AppLanguage.INDONESIAN) {
        R.string.settings_language_indonesian
    } else {
        R.string.settings_language_english
    },
)
