package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.djtech.monai.core.model.ThemeMode
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/** The theme picked in Settings; kept across sessions, so signing out doesn't reset it. */
@Singleton
class ThemePreferenceStore @Inject constructor(
    @AppPreferences private val dataStore: DataStore<Preferences>,
) {
    val themeMode: Flow<ThemeMode> = dataStore.data
        // An unknown stored name (e.g. from a newer build) falls back to the system setting.
        .map { prefs -> ThemeMode.entries.firstOrNull { it.name == prefs[THEME_MODE] } ?: ThemeMode.SYSTEM }
        .distinctUntilChanged()

    suspend fun setThemeMode(mode: ThemeMode) {
        dataStore.edit { it[THEME_MODE] = mode.name }
    }

    internal companion object {
        val THEME_MODE = stringPreferencesKey("theme_mode")
    }
}
