package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

class SessionStoreTest {

    @get:Rule
    val tmp = TemporaryFolder()

    // DataStore does real file I/O, so it gets a real dispatcher.
    private val dataStoreScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val dataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.create(scope = dataStoreScope) {
            tmp.root.resolve("session.preferences_pb")
        }
    }

    @After
    fun tearDown() {
        dataStoreScope.cancel()
    }

    @Test
    fun `starts signed out when nothing is stored`() = runTest {
        val store = store()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
        assertNull(store.accessToken())
    }

    @Test
    fun `saving a token signs in and serves it from memory`() = runTest {
        val store = store()

        store.saveToken("token-1")

        assertEquals(SessionState.SignedIn, store.awaitLoaded())
        assertEquals("token-1", store.accessToken())
    }

    @Test
    fun `stores the token encrypted`() = runTest {
        val store = store()

        store.saveToken("token-1")

        val raw = dataStore.data.first()[SessionStore.ACCESS_TOKEN]
        assertNotEquals("token-1", raw)
        assertEquals(FakeTokenCipher.encrypt("token-1"), raw)
    }

    @Test
    fun `restores a stored token before the first load finishes`() = runTest {
        dataStore.edit { it[SessionStore.ACCESS_TOKEN] = FakeTokenCipher.encrypt("saved") }

        // OkHttp may ask before the state flow has loaded; it must not get null.
        val store = store()

        assertEquals("saved", store.accessToken())
        assertEquals(SessionState.SignedIn, store.awaitLoaded())
    }

    @Test
    fun `a token that cannot be decrypted counts as signed out`() = runTest {
        // E.g. restored onto a device without the Keystore key.
        dataStore.edit { it[SessionStore.ACCESS_TOKEN] = "garbage" }

        val store = store()

        assertNull(store.accessToken())
        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    @Test
    fun `clear signs out`() = runTest {
        val store = store()
        store.saveToken("token-1")

        store.clear()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
        assertNull(store.accessToken())
    }

    @Test
    fun `clearIfCurrent removes the token it was given`() = runTest {
        val store = store()
        store.saveToken("token-1")

        store.clearIfCurrent("token-1")

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
        assertNull(store.accessToken())
    }

    @Test
    fun `clearIfCurrent keeps a newer token`() = runTest {
        // A request sent with token-1 fails after the user already signed in again.
        val store = store()
        store.saveToken("token-2")

        store.clearIfCurrent("token-1")

        assertEquals(SessionState.SignedIn, store.awaitLoaded())
        assertEquals("token-2", store.accessToken())
    }

    private fun TestScope.store() = SessionStore(
        dataStore = dataStore,
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = StandardTestDispatcher(testScheduler),
    )

    private suspend fun SessionStore.awaitLoaded(): SessionState =
        sessionState.first { it != SessionState.Loading }
}

/** Reversible stand-in for the Keystore cipher; rejects anything it did not encrypt. */
private object FakeTokenCipher : TokenCipher {
    private const val PREFIX = "enc:"

    override fun encrypt(plaintext: String): String = PREFIX + plaintext.reversed()

    override fun decrypt(ciphertext: String): String? =
        ciphertext.takeIf { it.startsWith(PREFIX) }?.removePrefix(PREFIX)?.reversed()
}
