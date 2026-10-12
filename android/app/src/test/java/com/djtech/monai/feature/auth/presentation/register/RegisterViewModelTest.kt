package com.djtech.monai.feature.auth.presentation.register

import androidx.lifecycle.SavedStateHandle
import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import com.djtech.monai.feature.auth.domain.usecase.FakeAuthRepository
import com.djtech.monai.feature.auth.domain.usecase.RegisterUseCase
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class RegisterViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val repository = FakeAuthRepository()
    private val savedState = SavedStateHandle()
    private val viewModel by lazy { RegisterViewModel(RegisterUseCase(repository), savedState) }

    private val state get() = viewModel.state.value

    private fun fillValidForm() {
        viewModel.onIntent(RegisterIntent.NameChanged("Joshua"))
        viewModel.onIntent(RegisterIntent.EmailChanged("joshua@example.com"))
        viewModel.onIntent(RegisterIntent.PasswordChanged("secretpass"))
    }

    @Test
    fun `the password hint is met at eight characters`() {
        viewModel.onIntent(RegisterIntent.PasswordChanged("1234567"))
        assertFalse(state.passwordLongEnough)

        viewModel.onIntent(RegisterIntent.PasswordChanged("12345678"))
        assertTrue(state.passwordLongEnough)
    }

    @Test
    fun `an invalid form shows every field error without calling the server`() =
        runTest(mainDispatcherRule.dispatcher) {
            viewModel.onIntent(RegisterIntent.EmailChanged("joshua"))
            viewModel.onIntent(RegisterIntent.PasswordChanged("short"))

            viewModel.onIntent(RegisterIntent.Submit)
            advanceUntilIdle()

            assertEquals(UiText.Resource(R.string.auth_field_name_required), state.nameError)
            assertEquals(UiText.Resource(R.string.auth_field_email_invalid), state.emailError)
            assertEquals(UiText.Resource(R.string.auth_field_too_short, 8), state.passwordError)
            assertTrue(repository.calls.isEmpty())
        }

    @Test
    fun `submitting calls register with the typed values`() = runTest(mainDispatcherRule.dispatcher) {
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()

        assertEquals(listOf("register(Joshua, joshua@example.com, secretpass)"), repository.calls)
        assertTrue(state.isSubmitting)
    }

    @Test
    fun `a registered email is flagged on the email field`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(AuthError.EmailAlreadyRegistered)
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.register_email_taken), state.emailError)
        assertTrue(state.emailTaken)
        assertNull(state.formError)
        assertFalse(state.isSubmitting)

        viewModel.onIntent(RegisterIntent.EmailChanged("other@example.com"))
        assertNull(state.emailError)
        assertFalse(state.emailTaken)
    }

    @Test
    fun `server field errors land on their fields`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(
            AuthError.InvalidFields(
                listOf(
                    AuthFieldError(AuthField.NAME, FieldIssue.TooLong(100)),
                    AuthFieldError(AuthField.PASSWORD, FieldIssue.Invalid),
                ),
            ),
        )
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.auth_field_too_long, 100), state.nameError)
        assertNull(state.emailError)
        assertEquals(UiText.Resource(R.string.auth_field_invalid), state.passwordError)
    }

    @Test
    fun `other failures show the banner until a field changes`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(AuthError.Network)
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()
        assertEquals(UiText.Resource(R.string.auth_error_network), state.formError)

        viewModel.onIntent(RegisterIntent.NameChanged("Josh"))
        assertNull(state.formError)
    }

    @Test
    fun `a second submit while in flight is ignored`() = runTest(mainDispatcherRule.dispatcher) {
        repository.gate = CompletableDeferred()
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()
        viewModel.onIntent(RegisterIntent.Submit)
        repository.gate?.complete(Unit)
        advanceUntilIdle()

        assertEquals(1, repository.calls.size)
    }

    @Test
    fun `name and email survive process death but the password does not`() {
        fillValidForm()

        val restored = RegisterViewModel(RegisterUseCase(repository), savedState).state.value

        assertEquals("Joshua", restored.name)
        assertEquals("joshua@example.com", restored.email)
        assertEquals("", restored.password)
    }

    @Test
    fun `sign in navigates to sign in`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(RegisterIntent.SignIn)

        assertEquals(RegisterEffect.NavigateToSignIn, viewModel.effects.first())
    }
}
