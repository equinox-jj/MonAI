package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.djtech.monai.core.network.NetworkJson
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import kotlinx.serialization.SerializationException
import javax.inject.Inject
import javax.inject.Singleton

/**
 * The user's last transaction searches, newest first. It is the user's data, so it is cleared
 * with the rest of the local cache on logout and session expiry.
 */
@Singleton
class SearchHistoryStore @Inject constructor(
    @AppPreferences private val dataStore: DataStore<Preferences>,
) {
    val recentSearches: Flow<List<String>> = dataStore.data
        .map { decode(it[RECENT_SEARCHES]) }
        .distinctUntilChanged()

    /** Moves [query] to the front; the same text in another case replaces the old entry. */
    suspend fun add(query: String) {
        val text = query.trim()
        if (text.isEmpty()) return
        dataStore.edit { prefs ->
            val kept = decode(prefs[RECENT_SEARCHES]).filterNot { it.equals(text, ignoreCase = true) }
            prefs[RECENT_SEARCHES] = NetworkJson.encodeToString((listOf(text) + kept).take(MAX_RECENT_SEARCHES))
        }
    }

    suspend fun clear() {
        dataStore.edit { it.remove(RECENT_SEARCHES) }
    }

    private fun decode(value: String?): List<String> = try {
        value?.let { NetworkJson.decodeFromString<List<String>>(it) }.orEmpty()
    } catch (_: SerializationException) {
        emptyList()
    }

    internal companion object {
        const val MAX_RECENT_SEARCHES = 5
        val RECENT_SEARCHES = stringPreferencesKey("recent_transaction_searches")
    }
}
