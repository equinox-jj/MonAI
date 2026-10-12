package com.djtech.monai.feature.auth.presentation.register

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator

/**
 * @param emailTaken the email error is "already has an account", which offers a sign-in link.
 * @param formError a problem with the whole attempt (offline, rate limited), shown as a banner.
 * @param isSubmitting a register call is running, or it succeeded and the session is switching screens.
 */
@Immutable
data class RegisterState(
    val name: String = "",
    val email: String = "",
    val password: String = "",
    val nameError: UiText? = null,
    val emailError: UiText? = null,
    val passwordError: UiText? = null,
    val emailTaken: Boolean = false,
    val formError: UiText? = null,
    val isSubmitting: Boolean = false,
) {
    /** Drives the live "At least 8 characters" hint; counted like the validator, in code points. */
    val passwordLongEnough: Boolean
        get() = password.codePointCount(0, password.length) >= AuthInputValidator.PASSWORD_MIN
}

sealed interface RegisterIntent {
    data class NameChanged(val value: String) : RegisterIntent
    data class EmailChanged(val value: String) : RegisterIntent
    data class PasswordChanged(val value: String) : RegisterIntent
    data object Submit : RegisterIntent

    /** "Sign in" at the bottom, or "Sign in instead" under a registered email. */
    data object SignIn : RegisterIntent
}

sealed interface RegisterEffect {
    data object NavigateToSignIn : RegisterEffect
}
