package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/** Remembers that onboarding was finished, so it only shows on the first launch after install. */
@Singleton
class OnboardingStore @Inject constructor(
    @AppPreferences private val dataStore: DataStore<Preferences>,
) {
    val isCompleted: Flow<Boolean> = dataStore.data
        .map { it[ONBOARDING_COMPLETED] == true }
        .distinctUntilChanged()

    suspend fun markCompleted() {
        dataStore.edit { it[ONBOARDING_COMPLETED] = true }
    }

    internal companion object {
        val ONBOARDING_COMPLETED = booleanPreferencesKey("onboarding_completed")
    }
}
