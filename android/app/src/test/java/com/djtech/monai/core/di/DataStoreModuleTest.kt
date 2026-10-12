package com.djtech.monai.core.di

import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

class DataStoreModuleTest {

    @get:Rule
    val tmp = TemporaryFolder()

    private val dataStoreScope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    @After
    fun tearDown() {
        dataStoreScope.cancel()
    }

    // Left in place, a damaged file would fail every read and write, so every launch.
    @Test
    fun `a corrupt preferences file is replaced so it reads as empty and takes writes`() = runTest {
        val file = tmp.root.resolve("session.preferences_pb").apply { writeText("not a protobuf") }
        val dataStore = createPreferencesDataStore(dataStoreScope) { file }

        assertEquals(emptyPreferences(), dataStore.data.first())

        dataStore.edit { it[KEY] = "value" }
        assertEquals("value", dataStore.data.first()[KEY])
    }

    private companion object {
        val KEY = stringPreferencesKey("key")
    }
}
