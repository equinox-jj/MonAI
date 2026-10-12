package com.djtech.monai.feature.auth.presentation.signin

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthField

/**
 * @param formError a problem with the whole attempt (wrong credentials, offline), shown as a banner.
 * @param isSubmitting a login is running, or it succeeded and the session is switching screens.
 */
@Immutable
data class SignInState(
    val email: String = "",
    val password: String = "",
    val emailError: UiText? = null,
    val passwordError: UiText? = null,
    val formError: UiText? = null,
    val isSubmitting: Boolean = false,
)

sealed interface SignInIntent {
    data class EmailChanged(val value: String) : SignInIntent
    data class PasswordChanged(val value: String) : SignInIntent
    data object Submit : SignInIntent
    data object CreateAccount : SignInIntent
}

sealed interface SignInEffect {
    /** Carries the typed email so Register can start with it. */
    data class NavigateToRegister(val email: String) : SignInEffect

    /** A submit failed on [field]: focus it so the keyboard and TalkBack land on the error. */
    data class FocusField(val field: AuthField) : SignInEffect
}
