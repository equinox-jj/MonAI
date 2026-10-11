package com.djtech.monai

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

class MainViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `is loading until the stored session is read`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = subscribed(MainViewModel(store()))

        assertEquals(SessionState.Loading, viewModel.sessionState.value)

        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.sessionState.value)
    }

    @Test
    fun `follows sign in and sign out`() = runTest(mainDispatcherRule.dispatcher) {
        val store = store()
        val viewModel = subscribed(MainViewModel(store))

        store.saveToken("token-1")
        advanceUntilIdle()
        assertEquals(SessionState.SignedIn, viewModel.sessionState.value)

        // Session expiry clears the token the same way, so it lands on SignedOut too.
        store.clearIfCurrent("token-1")
        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.sessionState.value)
    }

    private fun TestScope.store() = SessionStore(
        dataStore = InMemoryPreferencesDataStore(),
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = mainDispatcherRule.dispatcher,
    )

    /** WhileUiSubscribed only updates while someone is subscribed, as the UI would be. */
    private fun TestScope.subscribed(viewModel: MainViewModel) = viewModel.also {
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { it.sessionState.collect {} }
    }
}
