package com.djtech.monai.feature.auth.presentation.register

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.usecase.RegisterUseCase
import com.djtech.monai.feature.auth.presentation.common.fieldMessage
import com.djtech.monai.feature.auth.presentation.common.toFormErrorText
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

@HiltViewModel(assistedFactory = RegisterViewModel.Factory::class)
class RegisterViewModel @AssistedInject constructor(
    private val register: RegisterUseCase,
    private val savedState: SavedStateHandle,
    @Assisted initialEmail: String,
) : ViewModel() {

    // Name and email survive process death; the password is never written to the saved state.
    // An email edited here wins over the one handed over from Sign in.
    private val mutableState = MutableStateFlow(
        RegisterState(name = savedState[KEY_NAME] ?: "", email = savedState[KEY_EMAIL] ?: initialEmail),
    )
    val state: StateFlow<RegisterState> = mutableState.asStateFlow()

    private val effectChannel = Channel<RegisterEffect>(Channel.BUFFERED)
    val effects: Flow<RegisterEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: RegisterIntent) {
        when (intent) {
            is RegisterIntent.NameChanged -> {
                savedState[KEY_NAME] = intent.value
                mutableState.update { it.copy(name = intent.value, nameError = null, formError = null) }
            }

            is RegisterIntent.EmailChanged -> {
                savedState[KEY_EMAIL] = intent.value
                mutableState.update {
                    it.copy(
                        email = intent.value,
                        emailError = null,
                        emailTaken = false,
                        formError = null,
                    )
                }
            }

            is RegisterIntent.PasswordChanged -> mutableState.update {
                it.copy(password = intent.value, passwordError = null, formError = null)
            }

            RegisterIntent.Submit -> submit()
            RegisterIntent.SignIn -> send(RegisterEffect.NavigateToSignIn(mutableState.value.email))
        }
    }

    private fun submit() {
        val current = mutableState.value
        if (current.isSubmitting) return
        mutableState.update { it.copy(isSubmitting = true, formError = null) }
        viewModelScope.launch {
            when (val result = register(current.name, current.email, current.password)) {
                // The saved token flips the session to SignedIn and the app leaves this graph,
                // so the form stays busy instead of briefly becoming submittable again.
                is Outcome.Success -> Unit
                is Outcome.Failure -> {
                    mutableState.update { it.withError(result.error) }
                    mutableState.value.firstInvalidField()?.let { send(RegisterEffect.FocusField(it)) }
                }
            }
        }
    }

    // In layout order, whatever order the server listed the errors in.
    private fun RegisterState.firstInvalidField(): AuthField? = when {
        nameError != null -> AuthField.NAME
        emailError != null -> AuthField.EMAIL
        passwordError != null -> AuthField.PASSWORD
        else -> null
    }

    private fun RegisterState.withError(error: AuthError): RegisterState = when (error) {
        is AuthError.InvalidFields -> copy(
            isSubmitting = false,
            nameError = error.errors.fieldMessage(AuthField.NAME),
            emailError = error.errors.fieldMessage(AuthField.EMAIL),
            passwordError = error.errors.fieldMessage(AuthField.PASSWORD),
            emailTaken = false,
        )

        AuthError.EmailAlreadyRegistered -> copy(
            isSubmitting = false,
            emailError = UiText.Resource(R.string.register_email_taken),
            emailTaken = true,
        )

        else -> copy(isSubmitting = false, formError = error.toFormErrorText())
    }

    private fun send(effect: RegisterEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    @AssistedFactory
    interface Factory {
        fun create(initialEmail: String): RegisterViewModel
    }

    private companion object {
        const val KEY_NAME = "name"
        const val KEY_EMAIL = "email"
    }
}
