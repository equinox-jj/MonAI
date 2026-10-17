package com.djtech.monai.feature.auth.presentation.signin

import androidx.lifecycle.SavedStateHandle
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import com.djtech.monai.feature.auth.domain.usecase.FakeAuthRepository
import com.djtech.monai.feature.auth.domain.usecase.LoginUseCase
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

class SignInViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val repository = FakeAuthRepository()
    private val savedState = SavedStateHandle()
    private val viewModel by lazy { viewModel() }

    private fun viewModel(initialEmail: String = "") =
        SignInViewModel(LoginUseCase(repository), savedState, initialEmail)

    private val state get() = viewModel.state.value

    private fun fillValidForm() {
        viewModel.onIntent(SignInIntent.EmailChanged("joshua@example.com"))
        viewModel.onIntent(SignInIntent.PasswordChanged("password1"))
    }

    @Test
    fun `typing updates the fields`() {
        fillValidForm()

        assertEquals("joshua@example.com", state.email)
        assertEquals("password1", state.password)
    }

    @Test
    fun `an invalid form shows field errors without calling the server`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(SignInIntent.EmailChanged("joshua"))
        viewModel.onIntent(SignInIntent.PasswordChanged(""))

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.auth_field_email_invalid), state.emailError)
        assertEquals(UiText.Resource(R.string.auth_field_password_required), state.passwordError)
        assertFalse(state.isSubmitting)
        assertTrue(repository.calls.isEmpty())
    }

    @Test
    fun `submitting calls login with the typed values`() = runTest(mainDispatcherRule.dispatcher) {
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertEquals(listOf("login(joshua@example.com, password1)"), repository.calls)
        assertNull(state.formError)
    }

    @Test
    fun `wrong credentials show the banner`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(AuthError.InvalidCredentials)
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.auth_error_invalid_credentials), state.formError)
        assertFalse(state.isSubmitting)
    }

    @Test
    fun `network and rate limit failures show their banners`() = runTest(mainDispatcherRule.dispatcher) {
        fillValidForm()

        repository.userResult = Outcome.Failure(AuthError.Network)
        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()
        assertEquals(UiText.Resource(R.string.auth_error_network), state.formError)

        repository.userResult = Outcome.Failure(AuthError.RateLimited(null))
        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()
        assertEquals(UiText.Resource(R.string.auth_error_rate_limited), state.formError)
    }

    @Test
    fun `server field errors land on their fields`() = runTest(mainDispatcherRule.dispatcher) {
        repository.userResult = Outcome.Failure(
            AuthError.InvalidFields(listOf(AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat))),
        )
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.auth_field_email_invalid), state.emailError)
        assertNull(state.formError)
    }

    @Test
    fun `field errors focus the first invalid field in layout order`() = runTest(mainDispatcherRule.dispatcher) {
        // The server may list fields in any order.
        repository.userResult = Outcome.Failure(
            AuthError.InvalidFields(
                listOf(
                    AuthFieldError(AuthField.PASSWORD, FieldIssue.Invalid),
                    AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat),
                ),
            ),
        )
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)

        assertEquals(SignInEffect.FocusField(AuthField.EMAIL), viewModel.effects.first())
    }

    @Test
    fun `a local password error focuses the password`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(SignInIntent.EmailChanged("joshua@example.com"))

        viewModel.onIntent(SignInIntent.Submit)

        assertEquals(SignInEffect.FocusField(AuthField.PASSWORD), viewModel.effects.first())
    }

    @Test
    fun `a banner error leaves focus alone`() = runTest(mainDispatcherRule.dispatcher) {
        val effects = mutableListOf<SignInEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        repository.userResult = Outcome.Failure(AuthError.InvalidCredentials)
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertTrue(effects.isEmpty())
    }

    @Test
    fun `editing a field clears its error and the banner`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()
        repository.userResult = Outcome.Failure(AuthError.InvalidCredentials)

        viewModel.onIntent(SignInIntent.EmailChanged("j"))

        assertNull(state.emailError)
        assertEquals(UiText.Resource(R.string.auth_field_password_required), state.passwordError)

        fillValidForm()
        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()
        viewModel.onIntent(SignInIntent.PasswordChanged("password2"))

        assertNull(state.formError)
    }

    @Test
    fun `stays submitting while the call is in flight and ignores a second submit`() =
        runTest(mainDispatcherRule.dispatcher) {
            val gate = CompletableDeferred<Unit>()
            repository.gate = gate
            fillValidForm()

            viewModel.onIntent(SignInIntent.Submit)
            advanceUntilIdle()
            assertTrue(state.isSubmitting)

            viewModel.onIntent(SignInIntent.Submit)
            gate.complete(Unit)
            advanceUntilIdle()

            assertEquals(1, repository.calls.size)
        }

    @Test
    fun `success keeps the form busy until the session switches screens`() = runTest(mainDispatcherRule.dispatcher) {
        fillValidForm()

        viewModel.onIntent(SignInIntent.Submit)
        advanceUntilIdle()

        assertTrue(state.isSubmitting)
    }

    @Test
    fun `the email survives process death but the password does not`() {
        fillValidForm()

        val restored = viewModel()

        assertEquals("joshua@example.com", restored.state.value.email)
        assertEquals("", restored.state.value.password)
    }

    @Test
    fun `starts with the email handed over from register`() {
        val viewModel = viewModel(initialEmail = "joshua@example.com")

        assertEquals("joshua@example.com", viewModel.state.value.email)
    }

    @Test
    fun `an email edited here wins over the handed-over one after process death`() {
        viewModel(initialEmail = "joshua@example.com")
            .onIntent(SignInIntent.EmailChanged("josh@example.com"))

        val restored = viewModel(initialEmail = "joshua@example.com")

        assertEquals("josh@example.com", restored.state.value.email)
    }

    @Test
    fun `create account hands the typed email to register`() = runTest(mainDispatcherRule.dispatcher) {
        viewModel.onIntent(SignInIntent.EmailChanged("joshua@example.com"))

        viewModel.onIntent(SignInIntent.CreateAccount)

        assertEquals(SignInEffect.NavigateToRegister("joshua@example.com"), viewModel.effects.first())
    }
}
