package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsDialog

/** Confirms signing out here or everywhere. */
@Composable
internal fun SettingsDialogs(
    dialog: SettingsDialog?,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    when (dialog) {
        null -> Unit
        SettingsDialog.SignOut -> MonAIAlertDialog(
            title = stringResource(R.string.settings_sign_out_title),
            message = stringResource(R.string.settings_sign_out_message),
            confirmLabel = stringResource(R.string.settings_sign_out),
            onConfirm = onConfirm,
            onDismissRequest = onDismiss,
            dismissLabel = stringResource(R.string.settings_cancel),
            icon = MonAIIcons.Logout,
            tone = MonAIAlertTone.Info,
        )

        SettingsDialog.SignOutAllDevices -> MonAIAlertDialog(
            title = stringResource(R.string.settings_sign_out_all_title),
            message = stringResource(R.string.settings_sign_out_all_message),
            confirmLabel = stringResource(R.string.settings_sign_out_all),
            onConfirm = onConfirm,
            onDismissRequest = onDismiss,
            dismissLabel = stringResource(R.string.settings_cancel),
            icon = MonAIIcons.Devices,
            tone = MonAIAlertTone.Warning,
            destructive = true,
        )
    }
}
