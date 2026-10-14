package com.djtech.monai.feature.auth.presentation.changepassword

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator

/**
 * @param formError a problem with the whole attempt (offline, rate limited), shown as a banner.
 * @param isSaving a change is running, or it succeeded and the app is signing out.
 */
@Immutable
data class ChangePasswordState(
    val currentPassword: String = "",
    val newPassword: String = "",
    val currentPasswordError: UiText? = null,
    val newPasswordError: UiText? = null,
    val formError: UiText? = null,
    val isSaving: Boolean = false,
) {
    val canSave: Boolean
        get() = currentPassword.isNotEmpty() && newPassword.isNotEmpty() && !isSaving

    /** Drives the live "At least 8 characters" hint, with the validator's own rule. */
    val newPasswordLongEnough: Boolean
        get() = AuthInputValidator.isPasswordLongEnough(newPassword)
}

sealed interface ChangePasswordIntent {
    data class CurrentPasswordChanged(val value: String) : ChangePasswordIntent
    data class NewPasswordChanged(val value: String) : ChangePasswordIntent
    data object Save : ChangePasswordIntent
    data object Back : ChangePasswordIntent
}

sealed interface ChangePasswordEffect {
    /** Back was pressed. A successful save needs no effect: the session ends and the app signs out. */
    data object Close : ChangePasswordEffect

    /** A save failed on [field]: focus it so the keyboard and TalkBack land on the error. */
    data class FocusField(val field: AuthField) : ChangePasswordEffect
}
