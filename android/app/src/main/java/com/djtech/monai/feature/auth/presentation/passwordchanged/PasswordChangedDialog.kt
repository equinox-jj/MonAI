package com.djtech.monai.feature.auth.presentation.passwordchanged

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.window.DialogProperties
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * Shown over the app after the password was changed. The session is already cleared, so the only
 * way out is to sign in with the new password: back and outside taps don't dismiss it.
 */
@Composable
fun PasswordChangedDialog(onSignIn: () -> Unit, modifier: Modifier = Modifier) {
    MonAIAlertDialog(
        title = stringResource(R.string.password_changed_title),
        message = stringResource(R.string.password_changed_body),
        confirmLabel = stringResource(R.string.password_changed_sign_in),
        onConfirm = onSignIn,
        onDismissRequest = {},
        modifier = modifier,
        icon = MonAIIcons.Lock,
        tone = MonAIAlertTone.Success,
        properties = DialogProperties(dismissOnBackPress = false, dismissOnClickOutside = false),
    )
}

@PreviewLightDark
@Composable
private fun PasswordChangedDialogPreview() {
    MonAITheme { PasswordChangedDialog(onSignIn = {}) }
}
