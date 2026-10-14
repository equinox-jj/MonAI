package com.djtech.monai.core.common.locale

import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import com.djtech.monai.core.model.AppLanguage
import javax.inject.Inject

/** Reads and changes the app's language, independent of the phone's. */
interface AppLocaleManager {
    fun currentLanguage(): AppLanguage

    /** Applies the new language to the visible activities (MainActivity handles it without recreating). */
    fun setLanguage(language: AppLanguage)
}

/** Backed by AppCompat's per-app locales: the system setting on API 33+, a stored value below. */
class AppCompatLocaleManager @Inject constructor() : AppLocaleManager {

    override fun currentLanguage(): AppLanguage {
        val locales = AppCompatDelegate.getApplicationLocales()
        if (locales.isEmpty) return AppLanguage.SYSTEM
        return languageOf(locales[0]?.language)
    }

    override fun setLanguage(language: AppLanguage) {
        val locales = language.tag?.let(LocaleListCompat::forLanguageTags) ?: LocaleListCompat.getEmptyLocaleList()
        AppCompatDelegate.setApplicationLocales(locales)
    }
}

/** Java still reports Indonesian with its legacy code `in` on some versions. */
fun languageOf(code: String?): AppLanguage = when (code) {
    "id", "in" -> AppLanguage.INDONESIAN
    "en" -> AppLanguage.ENGLISH
    else -> AppLanguage.SYSTEM
}
