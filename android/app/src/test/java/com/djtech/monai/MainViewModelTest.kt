package com.djtech.monai

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.OnboardingStore
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class MainViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `is loading until the stored session is read`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = subscribed(MainViewModel(store(), onboardingStore))

        assertEquals(SessionState.Loading, viewModel.state.value.sessionState)
        assertTrue(viewModel.state.value.isLoading)

        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.state.value.sessionState)
    }

    @Test
    fun `follows sign in and sign out`() = runTest(mainDispatcherRule.dispatcher) {
        val store = store()
        val viewModel = subscribed(MainViewModel(store, onboardingStore))

        store.saveToken("token-1")
        advanceUntilIdle()
        assertEquals(SessionState.SignedIn, viewModel.state.value.sessionState)

        store.clear()
        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.state.value.sessionState)
    }

    @Test
    fun `an expired session signs out once acknowledged`() = runTest(mainDispatcherRule.dispatcher) {
        val store = store()
        val viewModel = subscribed(MainViewModel(store, onboardingStore))
        store.saveToken("token-1")

        store.clearIfCurrent("token-1")
        advanceUntilIdle()
        assertEquals(SessionState.Expired, viewModel.state.value.sessionState)

        viewModel.onSessionExpiredAcknowledged()
        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.state.value.sessionState)
    }

    @Test
    fun `reports onboarding as completed once it is marked`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = subscribed(MainViewModel(store(), onboardingStore))
        advanceUntilIdle()
        assertFalse(viewModel.state.value.onboardingCompleted)

        onboardingStore.markCompleted()
        advanceUntilIdle()
        assertTrue(viewModel.state.value.onboardingCompleted)
    }

    private val onboardingStore = OnboardingStore(InMemoryPreferencesDataStore())

    private fun TestScope.store() = SessionStore(
        dataStore = InMemoryPreferencesDataStore(),
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = mainDispatcherRule.dispatcher,
    )

    /** WhileUiSubscribed only updates while someone is subscribed, as the UI would be. */
    private fun TestScope.subscribed(viewModel: MainViewModel) = viewModel.also {
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { it.state.collect {} }
    }
}
