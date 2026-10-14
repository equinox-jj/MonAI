package com.djtech.monai.feature.auth.presentation.changepassword.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.ContentType
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIPasswordField
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import com.djtech.monai.feature.auth.presentation.changepassword.ChangePasswordIntent
import com.djtech.monai.feature.auth.presentation.changepassword.ChangePasswordState
import com.djtech.monai.feature.auth.presentation.common.AuthFieldFocus
import com.djtech.monai.feature.auth.presentation.common.fieldTone

/** The current password, then the new one with its live length hint. Done on the keyboard saves. */
@Composable
internal fun ChangePasswordFields(
    state: ChangePasswordState,
    onIntent: (ChangePasswordIntent) -> Unit,
    fieldFocus: AuthFieldFocus,
    onSubmit: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val focusManager = LocalFocusManager.current
    val showLabel = stringResource(R.string.auth_show_password)
    val hideLabel = stringResource(R.string.auth_hide_password)
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4)) {
        MonAIPasswordField(
            value = state.currentPassword,
            onValueChange = { onIntent(ChangePasswordIntent.CurrentPasswordChanged(it)) },
            modifier = Modifier.focusRequester(fieldFocus.requester(AuthField.CURRENT_PASSWORD)),
            enabled = !state.isSaving,
            label = stringResource(R.string.change_password_current_label),
            placeholder = stringResource(R.string.change_password_current_placeholder),
            supportingText = state.currentPasswordError?.asString(),
            tone = state.currentPasswordError.fieldTone(),
            showPasswordLabel = showLabel,
            hidePasswordLabel = hideLabel,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password, imeAction = ImeAction.Next),
            keyboardActions = KeyboardActions(onNext = { focusManager.moveFocus(FocusDirection.Down) }),
            contentType = ContentType.Password,
        )
        // An error replaces the length hint; otherwise the hint turns green once it is met.
        val newPasswordError = state.newPasswordError
        MonAIPasswordField(
            value = state.newPassword,
            onValueChange = { onIntent(ChangePasswordIntent.NewPasswordChanged(it)) },
            modifier = Modifier.focusRequester(fieldFocus.requester(AuthField.NEW_PASSWORD)),
            enabled = !state.isSaving,
            label = stringResource(R.string.change_password_new_label),
            placeholder = stringResource(R.string.register_password_placeholder),
            supportingText = newPasswordError?.asString()
                ?: stringResource(R.string.register_password_hint, AuthInputValidator.PASSWORD_MIN),
            tone = when {
                newPasswordError != null -> MonAIFieldTone.Error
                state.newPasswordLongEnough -> MonAIFieldTone.Success
                else -> MonAIFieldTone.Neutral
            },
            showPasswordLabel = showLabel,
            hidePasswordLabel = hideLabel,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password, imeAction = ImeAction.Done),
            keyboardActions = KeyboardActions(onDone = { onSubmit() }),
            contentType = ContentType.NewPassword,
        )
    }
}
