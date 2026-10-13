package com.djtech.monai

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.OnboardingStore
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.datastore.ThemePreferenceStore
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.feature.auth.domain.usecase.ExpireSessionIfDueUseCase
import com.djtech.monai.feature.auth.domain.usecase.FakeAuthRepository
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

    private val errorLogger = RecordingErrorLogger()

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `is loading until the stored session is read`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = subscribed(mainViewModel())

        assertEquals(SessionState.Loading, viewModel.state.value.sessionState)
        assertTrue(viewModel.state.value.isLoading)

        advanceUntilIdle()
        assertEquals(SessionState.SignedOut, viewModel.state.value.sessionState)
    }

    @Test
    fun `follows sign in and sign out`() = runTest(mainDispatcherRule.dispatcher) {
        val store = store()
        val viewModel = subscribed(mainViewModel(store))

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
        val viewModel = subscribed(mainViewModel(store))
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
        val viewModel = subscribed(mainViewModel())
        advanceUntilIdle()
        assertFalse(viewModel.state.value.onboardingCompleted)

        onboardingStore.markCompleted()
        advanceUntilIdle()
        assertTrue(viewModel.state.value.onboardingCompleted)
    }

    private val onboardingStore = OnboardingStore(InMemoryPreferencesDataStore())
    private val authRepository = FakeAuthRepository()
    private val themeStore = ThemePreferenceStore(InMemoryPreferencesDataStore())

    @Test
    fun `follows the theme picked in settings`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = subscribed(mainViewModel())
        advanceUntilIdle()
        assertEquals(ThemeMode.SYSTEM, viewModel.state.value.themeMode)

        themeStore.setThemeMode(ThemeMode.DARK)
        advanceUntilIdle()
        assertEquals(ThemeMode.DARK, viewModel.state.value.themeMode)
    }

    @Test
    fun `coming to the foreground expires an overdue session`() = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = mainViewModel()

        viewModel.onAppForegrounded()
        advanceUntilIdle()

        assertEquals(listOf("expireSessionIfDue"), authRepository.calls)
    }

    private fun TestScope.mainViewModel(store: SessionStore = store()) = MainViewModel(
        store,
        onboardingStore,
        themeStore,
        ExpireSessionIfDueUseCase(authRepository),
    )

    private fun TestScope.store() = SessionStore(
        dataStore = InMemoryPreferencesDataStore(),
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = mainDispatcherRule.dispatcher,
        errorLogger = errorLogger,
    )

    /** WhileUiSubscribed only updates while someone is subscribed, as the UI would be. */
    private fun TestScope.subscribed(viewModel: MainViewModel) = viewModel.also {
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { it.state.collect {} }
    }
}
