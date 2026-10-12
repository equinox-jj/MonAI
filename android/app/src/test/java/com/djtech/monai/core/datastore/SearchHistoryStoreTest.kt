package com.djtech.monai.core.datastore

import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class SearchHistoryStoreTest {

    private val dataStore = InMemoryPreferencesDataStore()
    private val store = SearchHistoryStore(dataStore)

    @Test
    fun `is empty at first`() = runTest {
        assertEquals(emptyList<String>(), store.recentSearches.first())
    }

    @Test
    fun `keeps the last five searches, newest first`() = runTest {
        listOf("a", "b", "c", "d", "e", "f").forEach { store.add(it) }

        assertEquals(listOf("f", "e", "d", "c", "b"), SearchHistoryStore(dataStore).recentSearches.first())
    }

    @Test
    fun `searching again moves the text to the front without a duplicate`() = runTest {
        store.add("kopi")
        store.add("parkir")
        store.add("  KOPI ")

        assertEquals(listOf("KOPI", "parkir"), store.recentSearches.first())
    }

    @Test
    fun `blank text is not kept`() = runTest {
        store.add("   ")

        assertEquals(emptyList<String>(), store.recentSearches.first())
    }

    @Test
    fun `clear forgets every search`() = runTest {
        store.add("kopi")
        store.clear()

        assertEquals(emptyList<String>(), store.recentSearches.first())
    }
}
