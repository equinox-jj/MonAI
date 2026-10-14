package com.djtech.monai.feature.auth.presentation.changepassword

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import com.djtech.monai.feature.auth.domain.usecase.ChangePasswordUseCase
import com.djtech.monai.feature.auth.domain.usecase.FakeAuthRepository
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class ChangePasswordViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val repository = FakeAuthRepository()
    private val viewModel by lazy {
        ChangePasswordViewModel(ChangePasswordUseCase(repository))
    }
    private val state get() = viewModel.state.value

    private fun TestScope.collectEffects(): List<ChangePasswordEffect> =
        mutableListOf<ChangePasswordEffect>().also { effects ->
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        }

    private fun fill(current: String = "oldPass1", new: String = "newPass12") {
        viewModel.onIntent(ChangePasswordIntent.CurrentPasswordChanged(current))
        viewModel.onIntent(ChangePasswordIntent.NewPasswordChanged(new))
    }

    @Test
    fun `save is enabled once both fields are filled`() {
        assertFalse(state.canSave)

        viewModel.onIntent(ChangePasswordIntent.CurrentPasswordChanged("oldPass1"))
        assertFalse(state.canSave)

        viewModel.onIntent(ChangePasswordIntent.NewPasswordChanged("n"))
        assertTrue(state.canSave)
    }

    @Test
    fun `the length hint is met at eight characters`() {
        viewModel.onIntent(ChangePasswordIntent.NewPasswordChanged("1234567"))
        assertFalse(state.newPasswordLongEnough)

        viewModel.onIntent(ChangePasswordIntent.NewPasswordChanged("12345678"))
        assertTrue(state.newPasswordLongEnough)
    }

    @Test
    fun `saving changes the password and stays busy while the app signs out`() =
        runTest(mainDispatcherRule.dispatcher) {
            val effects = collectEffects()
            fill()

            viewModel.onIntent(ChangePasswordIntent.Save)
            advanceUntilIdle()

            assertEquals(listOf("changePassword(oldPass1, newPass12)"), repository.calls)
            assertTrue(state.isSaving)
            assertEquals(emptyList<ChangePasswordEffect>(), effects)
        }

    @Test
    fun `the form is busy while saving and ignores a second save`() = runTest(mainDispatcherRule.dispatcher) {
        val gate = CompletableDeferred<Unit>()
        repository.gate = gate
        fill()

        viewModel.onIntent(ChangePasswordIntent.Save)
        advanceUntilIdle()
        assertTrue(state.isSaving)

        viewModel.onIntent(ChangePasswordIntent.Save)
        gate.complete(Unit)
        advanceUntilIdle()

        assertEquals(1, repository.calls.size)
    }

    @Test
    fun `a reused password shows on the new password field and focuses it`() =
        runTest(mainDispatcherRule.dispatcher) {
            val effects = collectEffects()
            fill(current = "samePass1", new = "samePass1")

            viewModel.onIntent(ChangePasswordIntent.Save)
            advanceUntilIdle()

            assertEquals(UiText.Resource(R.string.auth_field_same_as_current), state.newPasswordError)
            assertNull(state.currentPasswordError)
            assertFalse(state.isSaving)
            assertTrue(repository.calls.isEmpty())
            assertEquals(listOf(ChangePasswordEffect.FocusField(AuthField.NEW_PASSWORD)), effects)
        }

    @Test
    fun `server field errors land on their fields, the first one focused`() =
        runTest(mainDispatcherRule.dispatcher) {
            val effects = collectEffects()
            repository.unitResult = Outcome.Failure(
                AuthError.InvalidFields(
                    listOf(
                        AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.TooLong(72)),
                        AuthFieldError(AuthField.CURRENT_PASSWORD, FieldIssue.Required),
                    ),
                ),
            )
            fill()

            viewModel.onIntent(ChangePasswordIntent.Save)
            advanceUntilIdle()

            assertEquals(UiText.Resource(R.string.auth_field_password_required), state.currentPasswordError)
            assertEquals(UiText.Resource(R.string.auth_field_too_long, 72), state.newPasswordError)
            assertEquals(listOf(ChangePasswordEffect.FocusField(AuthField.CURRENT_PASSWORD)), effects)
        }

    @Test
    fun `a wrong current password shows on that field`() = runTest(mainDispatcherRule.dispatcher) {
        val effects = collectEffects()
        repository.unitResult = Outcome.Failure(AuthError.WrongCurrentPassword)
        fill()

        viewModel.onIntent(ChangePasswordIntent.Save)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.change_password_wrong_current), state.currentPasswordError)
        assertNull(state.formError)
        assertEquals(listOf(ChangePasswordEffect.FocusField(AuthField.CURRENT_PASSWORD)), effects)
    }

    @Test
    fun `a network failure shows a form banner`() = runTest(mainDispatcherRule.dispatcher) {
        repository.unitResult = Outcome.Failure(AuthError.Network)
        fill()

        viewModel.onIntent(ChangePasswordIntent.Save)
        advanceUntilIdle()

        assertEquals(UiText.Resource(R.string.auth_error_network), state.formError)
        assertFalse(state.isSaving)
    }

    @Test
    fun `typing clears that field's error and the banner`() = runTest(mainDispatcherRule.dispatcher) {
        repository.unitResult = Outcome.Failure(AuthError.WrongCurrentPassword)
        fill()
        viewModel.onIntent(ChangePasswordIntent.Save)
        advanceUntilIdle()

        viewModel.onIntent(ChangePasswordIntent.CurrentPasswordChanged("oldPass2"))

        assertNull(state.currentPasswordError)
        assertNull(state.formError)
    }

    @Test
    fun `back closes without saving`() = runTest(mainDispatcherRule.dispatcher) {
        val effects = collectEffects()

        viewModel.onIntent(ChangePasswordIntent.Back)
        advanceUntilIdle()

        assertEquals(listOf(ChangePasswordEffect.Close), effects)
        assertTrue(repository.calls.isEmpty())
    }
}
