package com.djtech.monai.core.datastore

import androidx.datastore.preferences.core.edit
import com.djtech.monai.core.model.ThemeMode
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ThemePreferenceStoreTest {

    private val dataStore = InMemoryPreferencesDataStore()

    @Test
    fun `follows the system on a fresh install`() = runTest {
        assertEquals(ThemeMode.SYSTEM, ThemePreferenceStore(dataStore).themeMode.first())
    }

    @Test
    fun `keeps the picked mode`() = runTest {
        ThemePreferenceStore(dataStore).setThemeMode(ThemeMode.DARK)

        assertEquals(ThemeMode.DARK, ThemePreferenceStore(dataStore).themeMode.first())
    }

    @Test
    fun `an unknown stored value falls back to the system`() = runTest {
        dataStore.edit { it[ThemePreferenceStore.THEME_MODE] = "SEPIA" }

        assertEquals(ThemeMode.SYSTEM, ThemePreferenceStore(dataStore).themeMode.first())
    }
}
