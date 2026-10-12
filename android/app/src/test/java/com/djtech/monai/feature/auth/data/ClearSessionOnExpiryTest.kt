package com.djtech.monai.feature.auth.data

import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import com.djtech.monai.core.database.FakeLocalCache
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.SessionStore
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.job
import kotlinx.coroutines.joinAll
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

class ClearSessionOnExpiryTest {

    @get:Rule
    val tmp = TemporaryFolder()

    private val dataStoreScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val localCache = FakeLocalCache()

    @After
    fun tearDown() {
        dataStoreScope.cancel()
    }

    @Test
    fun `clears the token and the cache when the rejected token is current`() = runTest {
        val store = store()
        store.saveToken("token-1")

        expire(store, "token-1")

        assertNull(store.accessToken())
        assertEquals(1, localCache.clearCount)
    }

    @Test
    fun `keeps the cache when a newer login already replaced the token`() = runTest {
        val store = store()
        store.saveToken("token-2")

        expire(store, "token-1")

        assertEquals("token-2", store.accessToken())
        assertEquals(0, localCache.clearCount)
    }

    private fun TestScope.store() = SessionStore(
        dataStore = PreferenceDataStoreFactory.create(scope = dataStoreScope) {
            tmp.root.resolve("session.preferences_pb")
        },
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = StandardTestDispatcher(testScheduler),
    )

    // Runs the handler on its own scope and waits for the clear it launches.
    private suspend fun TestScope.expire(store: SessionStore, token: String) {
        val handlerScope = CoroutineScope(StandardTestDispatcher(testScheduler))
        ClearSessionOnExpiry(store, localCache, handlerScope).onSessionExpired(token)
        handlerScope.coroutineContext.job.children.toList().joinAll()
    }
}
