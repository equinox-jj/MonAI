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
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
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
    private val viewModel by lazy { viewModel() }

    private fun viewModel(initialEmail: String = "") =
        RegisterViewModel(RegisterUseCase(repository), savedState, initialEmail)

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
    fun `field errors focus the first invalid field in layout order`() = runTest(mainDispatcherRule.dispatcher) {
        // The server may list fields in any order.
        repository.userResult = Outcome.Failure(
            AuthError.InvalidFields(
                listOf(
                    AuthFieldError(AuthField.PASSWORD, FieldIssue.Invalid),
                    AuthFieldError(AuthField.NAME, FieldIssue.TooLong(100)),
                ),
            ),
        )
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)

        assertEquals(RegisterEffect.FocusField(AuthField.NAME), viewModel.effects.first())
    }

    @Test
    fun `a registered email focuses the email`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(AuthError.EmailAlreadyRegistered)
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)

        assertEquals(RegisterEffect.FocusField(AuthField.EMAIL), viewModel.effects.first())
    }

    @Test
    fun `a banner error leaves focus alone`() = runTest(mainDispatcherRule.dispatcher) {
        val effects = mutableListOf<RegisterEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        repository.userResult = Outcome.Failure(AuthError.Network)
        fillValidForm()

        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()

        assertTrue(effects.isEmpty())
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

        val restored = viewModel().state.value

        assertEquals("Joshua", restored.name)
        assertEquals("joshua@example.com", restored.email)
        assertEquals("", restored.password)
    }

    @Test
    fun `starts with the email handed over from sign in`() {
        val viewModel = viewModel(initialEmail = "joshua@example.com")

        assertEquals("joshua@example.com", viewModel.state.value.email)
    }

    @Test
    fun `an email edited here wins over the handed-over one after process death`() {
        viewModel(initialEmail = "joshua@example.com")
            .onIntent(RegisterIntent.EmailChanged("josh@example.com"))

        val restored = viewModel(initialEmail = "joshua@example.com")

        assertEquals("josh@example.com", restored.state.value.email)
    }

    @Test
    fun `sign in hands the typed email to sign in`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(AuthError.EmailAlreadyRegistered)
        fillValidForm()
        viewModel.onIntent(RegisterIntent.Submit)
        advanceUntilIdle()

        // "Sign in instead" under the taken email.
        viewModel.onIntent(RegisterIntent.SignIn)

        // The failed submit already focused the email field; the navigation follows it.
        assertEquals(
            RegisterEffect.NavigateToSignIn("joshua@example.com"),
            viewModel.effects.first { it is RegisterEffect.NavigateToSignIn },
        )
    }
}
