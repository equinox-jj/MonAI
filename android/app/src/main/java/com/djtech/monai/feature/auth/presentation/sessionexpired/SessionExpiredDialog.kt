package com.djtech.monai.feature.auth.presentation.sessionexpired

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
 * Shown over the app when the server rejected the token. The session is already cleared, so the only
 * way out is to sign in again: back and outside taps don't dismiss it.
 */
@Composable
fun SessionExpiredDialog(onSignInAgain: () -> Unit, modifier: Modifier = Modifier) {
    MonAIAlertDialog(
        title = stringResource(R.string.session_expired_title),
        message = stringResource(R.string.session_expired_body),
        confirmLabel = stringResource(R.string.session_expired_sign_in),
        onConfirm = onSignInAgain,
        onDismissRequest = {},
        modifier = modifier,
        icon = MonAIIcons.LockClock,
        tone = MonAIAlertTone.Info,
        properties = DialogProperties(dismissOnBackPress = false, dismissOnClickOutside = false),
    )
}

@PreviewLightDark
@Composable
private fun SessionExpiredDialogPreview() {
    MonAITheme { SessionExpiredDialog(onSignInAgain = {}) }
}
