package com.djtech.monai.feature.auth.presentation.changepassword

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.usecase.ChangePasswordUseCase
import com.djtech.monai.feature.auth.presentation.common.fieldMessage
import com.djtech.monai.feature.auth.presentation.common.toFormErrorText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/** Passwords are never written to the saved state, so they don't survive process death. */
@HiltViewModel
class ChangePasswordViewModel @Inject constructor(
    private val changePassword: ChangePasswordUseCase,
) : ViewModel() {

    private val mutableState = MutableStateFlow(ChangePasswordState())
    val state: StateFlow<ChangePasswordState> = mutableState.asStateFlow()

    private val effectChannel = Channel<ChangePasswordEffect>(Channel.BUFFERED)
    val effects: Flow<ChangePasswordEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: ChangePasswordIntent) {
        when (intent) {
            is ChangePasswordIntent.CurrentPasswordChanged -> mutableState.update {
                it.copy(currentPassword = intent.value, currentPasswordError = null, formError = null)
            }

            is ChangePasswordIntent.NewPasswordChanged -> mutableState.update {
                it.copy(newPassword = intent.value, newPasswordError = null, formError = null)
            }

            ChangePasswordIntent.Save -> save()
            ChangePasswordIntent.Back -> send(ChangePasswordEffect.Close)
        }
    }

    private fun save() {
        val current = mutableState.value
        if (current.isSaving) return
        mutableState.update { it.copy(isSaving = true, formError = null) }
        viewModelScope.launch {
            when (val result = changePassword(current.currentPassword, current.newPassword)) {
                // The session ends and the app shows the password-changed dialog, so the form stays
                // busy instead of briefly becoming submittable again.
                is Outcome.Success -> Unit
                is Outcome.Failure -> {
                    mutableState.update { it.withError(result.error) }
                    mutableState.value.firstInvalidField()?.let { send(ChangePasswordEffect.FocusField(it)) }
                }
            }
        }
    }

    // In layout order, whatever order the server listed the errors in.
    private fun ChangePasswordState.firstInvalidField(): AuthField? = when {
        currentPasswordError != null -> AuthField.CURRENT_PASSWORD
        newPasswordError != null -> AuthField.NEW_PASSWORD
        else -> null
    }

    private fun ChangePasswordState.withError(error: AuthError): ChangePasswordState = when (error) {
        is AuthError.InvalidFields -> copy(
            isSaving = false,
            currentPasswordError = error.errors.fieldMessage(AuthField.CURRENT_PASSWORD),
            newPasswordError = error.errors.fieldMessage(AuthField.NEW_PASSWORD),
        )

        AuthError.WrongCurrentPassword -> copy(
            isSaving = false,
            currentPasswordError = UiText.Resource(R.string.change_password_wrong_current),
        )

        else -> copy(isSaving = false, formError = error.toFormErrorText())
    }

    private fun send(effect: ChangePasswordEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}
