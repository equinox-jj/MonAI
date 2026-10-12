package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.lifecycle.SavedStateHandle
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.OnboardingStore
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class OnboardingViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val savedState = SavedStateHandle()
    private val onboardingStore = OnboardingStore(InMemoryPreferencesDataStore())
    private val viewModel = OnboardingViewModel(savedState, onboardingStore)

    private val page get() = viewModel.state.value.page

    @Test
    fun `starts on the first of three pages`() {
        val state = viewModel.state.value

        assertEquals(0, state.page)
        assertEquals(OnboardingPage.entries.size, state.pageCount)
        assertFalse(state.isLastPage)
    }

    @Test
    fun `next advances one page and stops on the last`() {
        viewModel.onIntent(OnboardingIntent.Next)
        assertEquals(1, page)

        viewModel.onIntent(OnboardingIntent.Next)
        assertEquals(2, page)
        assertTrue(viewModel.state.value.isLastPage)

        viewModel.onIntent(OnboardingIntent.Next)
        assertEquals(2, page)
    }

    @Test
    fun `back goes one page back and stops on the first`() {
        viewModel.onIntent(OnboardingIntent.PageSettled(2))

        viewModel.onIntent(OnboardingIntent.Back)
        assertEquals(1, page)

        viewModel.onIntent(OnboardingIntent.Back)
        viewModel.onIntent(OnboardingIntent.Back)
        assertEquals(0, page)
    }

    @Test
    fun `a swipe moves the state to the settled page`() {
        viewModel.onIntent(OnboardingIntent.PageSettled(1))

        assertEquals(1, page)
    }

    @Test
    fun `a settled page out of range is clamped`() {
        viewModel.onIntent(OnboardingIntent.PageSettled(9))
        assertEquals(2, page)

        viewModel.onIntent(OnboardingIntent.PageSettled(-1))
        assertEquals(0, page)
    }

    @Test
    fun `create account opens register`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(OnboardingIntent.CreateAccount)

        assertEquals(OnboardingEffect.NavigateToRegister, viewModel.effects.first())
    }

    @Test
    fun `skip opens register`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(OnboardingIntent.Skip)

        assertEquals(OnboardingEffect.NavigateToRegister, viewModel.effects.first())
    }

    @Test
    fun `sign in opens sign in`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(OnboardingIntent.SignIn)

        assertEquals(OnboardingEffect.NavigateToSignIn, viewModel.effects.first())
    }

    // Navigation replaces the top of the stack, so a second effect would override the first.
    @Test
    fun `only the first way out navigates`() = runTest(mainDispatcherRule.dispatcher) {
        val effects = mutableListOf<OnboardingEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }

        viewModel.onIntent(OnboardingIntent.CreateAccount)
        viewModel.onIntent(OnboardingIntent.SignIn)
        viewModel.onIntent(OnboardingIntent.CreateAccount)
        advanceUntilIdle()

        assertEquals(listOf(OnboardingEffect.NavigateToRegister), effects)
    }

    @Test
    fun `paging does not complete onboarding`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(OnboardingIntent.Next)
        viewModel.onIntent(OnboardingIntent.Next)

        assertFalse(onboardingStore.isCompleted.first())
    }

    @Test
    fun `leaving for register or sign in completes onboarding`() = runTest(mainDispatcherRule.dispatcher) {
        for (intent in listOf(OnboardingIntent.Skip, OnboardingIntent.CreateAccount, OnboardingIntent.SignIn)) {
            val store = OnboardingStore(InMemoryPreferencesDataStore())
            val viewModel = OnboardingViewModel(SavedStateHandle(), store)

            viewModel.onIntent(intent)
            viewModel.effects.first()

            assertTrue("$intent", store.isCompleted.first())
        }
    }

    @Test
    fun `the page survives process death`() {
        viewModel.onIntent(OnboardingIntent.Next)

        val restored = OnboardingViewModel(savedState, onboardingStore)

        assertEquals(1, restored.state.value.page)
    }
}
