package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import com.djtech.monai.core.common.log.RecordingErrorLogger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder
import java.io.IOException
import java.time.Instant

class SessionStoreTest {

    private val errorLogger = RecordingErrorLogger()

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

    // Otherwise the startup load fails, and the app crashes or stays on the splash.
    @Test
    fun `an unreadable session file counts as signed out`() = runTest {
        val store = store(dataStore = UnreadableDataStore)

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
        assertNull(store.accessToken())
        assertEquals(listOf("read failed"), errorLogger.errors.map { it.message })
    }

    @Test
    fun `a token is overdue once its expiry has passed`() = runTest {
        val store = store()
        store.saveToken("token-1", expiresAt = EXPIRY)

        assertNull(store.overdueToken(now = EXPIRY.minusSeconds(1)))
        assertEquals("token-1", store.overdueToken(now = EXPIRY))
    }

    @Test
    fun `the expiry survives a restart`() = runTest {
        store().saveToken("token-1", expiresAt = EXPIRY)

        assertEquals("token-1", store().overdueToken(now = EXPIRY.plusSeconds(1)))
    }

    @Test
    fun `a token saved without an expiry is never overdue`() = runTest {
        val store = store()
        store.saveToken("token-1", expiresAt = EXPIRY)
        store.saveToken("token-2")

        assertNull(store.overdueToken(now = EXPIRY.plusSeconds(1)))
    }

    @Test
    fun `nothing is overdue when signed out`() = runTest {
        val store = store()
        store.saveToken("token-1", expiresAt = EXPIRY)
        store.clear()

        assertNull(store.overdueToken(now = EXPIRY.plusSeconds(1)))
        assertNull(store().overdueToken(now = EXPIRY.plusSeconds(1)))
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

        assertTrue(store.clearIfCurrent("token-1"))
        assertEquals(SessionState.Expired, store.awaitLoaded())
        assertNull(store.accessToken())
    }

    @Test
    fun `clearIfCurrent keeps a newer token`() = runTest {
        // A request sent with token-1 fails after the user already signed in again.
        val store = store()
        store.saveToken("token-2")

        assertFalse(store.clearIfCurrent("token-1"))
        assertEquals(SessionState.SignedIn, store.awaitLoaded())
        assertEquals("token-2", store.accessToken())
    }

    @Test
    fun `clearIfCurrent marks the session expired until acknowledged`() = runTest {
        val store = store()
        store.saveToken("token-1")

        store.clearIfCurrent("token-1")

        assertEquals(SessionState.Expired, store.awaitLoaded())
        assertNull(store.accessToken())

        store.acknowledgeSignOutNotice()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    @Test
    fun `clearAfterPasswordChange signs out with a notice until acknowledged`() = runTest {
        val store = store()
        store.saveToken("token-1")

        store.clearAfterPasswordChange()

        assertEquals(SessionState.PasswordChanged, store.awaitLoaded())
        assertNull(store.accessToken())

        store.acknowledgeSignOutNotice()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    @Test
    fun `a stale clearIfCurrent does not mark the session expired`() = runTest {
        val store = store()
        store.saveToken("token-2")

        store.clearIfCurrent("token-1")
        store.clear()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    @Test
    fun `signing in after expiry clears the expired state`() = runTest {
        val store = store()
        store.saveToken("token-1")
        store.clearIfCurrent("token-1")

        store.saveToken("token-2")

        assertEquals(SessionState.SignedIn, store.awaitLoaded())
        store.clear()
        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    @Test
    fun `clear after expiry signs out without the expired state`() = runTest {
        val store = store()
        store.saveToken("token-1")
        store.clearIfCurrent("token-1")

        store.clear()

        assertEquals(SessionState.SignedOut, store.awaitLoaded())
    }

    private fun TestScope.store(dataStore: DataStore<Preferences> = this@SessionStoreTest.dataStore) = SessionStore(
        dataStore = dataStore,
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = StandardTestDispatcher(testScheduler),
        errorLogger = errorLogger,
    )

    // A file the system fails to read: an I/O error rather than damaged contents.
    private object UnreadableDataStore : DataStore<Preferences> {
        override val data: Flow<Preferences> = flow { throw IOException("read failed") }

        override suspend fun updateData(transform: suspend (t: Preferences) -> Preferences): Preferences =
            throw IOException("write failed")
    }

    private companion object {
        val EXPIRY: Instant = Instant.parse("2026-10-19T12:00:00Z")
    }

    private suspend fun SessionStore.awaitLoaded(): SessionState =
        sessionState.first { it != SessionState.Loading }
}

