package com.djtech.monai.feature.auth.presentation.signin

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.usecase.LoginUseCase
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

@HiltViewModel(assistedFactory = SignInViewModel.Factory::class)
class SignInViewModel @AssistedInject constructor(
    private val login: LoginUseCase,
    private val savedState: SavedStateHandle,
    @Assisted initialEmail: String,
) : ViewModel() {

    // Only the email survives process death; the password is never written to the saved state.
    // An email edited here wins over the one handed over from Register.
    private val mutableState = MutableStateFlow(SignInState(email = savedState[KEY_EMAIL] ?: initialEmail))
    val state: StateFlow<SignInState> = mutableState.asStateFlow()

    private val effectChannel = Channel<SignInEffect>(Channel.BUFFERED)
    val effects: Flow<SignInEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: SignInIntent) {
        when (intent) {
            is SignInIntent.EmailChanged -> {
                savedState[KEY_EMAIL] = intent.value
                mutableState.update { it.copy(email = intent.value, emailError = null, formError = null) }
            }

            is SignInIntent.PasswordChanged -> mutableState.update {
                it.copy(password = intent.value, passwordError = null, formError = null)
            }

            SignInIntent.Submit -> submit()
            SignInIntent.CreateAccount -> send(SignInEffect.NavigateToRegister(mutableState.value.email))
        }
    }

    private fun submit() {
        val current = mutableState.value
        if (current.isSubmitting) return
        mutableState.update { it.copy(isSubmitting = true, formError = null) }
        viewModelScope.launch {
            when (val result = login(current.email, current.password)) {
                // The saved token flips the session to SignedIn and the app leaves this graph,
                // so the form stays busy instead of briefly becoming submittable again.
                is Outcome.Success -> Unit
                is Outcome.Failure -> {
                    mutableState.update { it.withError(result.error) }
                    mutableState.value.firstInvalidField()?.let { send(SignInEffect.FocusField(it)) }
                }
            }
        }
    }

    // In layout order, whatever order the server listed the errors in.
    private fun SignInState.firstInvalidField(): AuthField? = when {
        emailError != null -> AuthField.EMAIL
        passwordError != null -> AuthField.PASSWORD
        else -> null
    }

    private fun SignInState.withError(error: AuthError): SignInState = when (error) {
        is AuthError.InvalidFields -> copy(
            isSubmitting = false,
            emailError = error.errors.fieldMessage(AuthField.EMAIL),
            passwordError = error.errors.fieldMessage(AuthField.PASSWORD),
        )

        else -> copy(isSubmitting = false, formError = error.toFormErrorText())
    }

    private fun send(effect: SignInEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    @AssistedFactory
    interface Factory {
        fun create(initialEmail: String): SignInViewModel
    }

    private companion object {
        const val KEY_EMAIL = "email"
    }
}
