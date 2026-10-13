package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.icon.MonAIIcons

/** The last check before the account and everything in it is deleted. */
@Composable
internal fun EditProfileDeleteDialog(onConfirm: () -> Unit, onDismiss: () -> Unit) {
    MonAIAlertDialog(
        title = stringResource(R.string.profile_delete_confirm_title),
        message = stringResource(R.string.profile_delete_confirm_message),
        confirmLabel = stringResource(R.string.profile_delete_confirm),
        onConfirm = onConfirm,
        onDismissRequest = onDismiss,
        dismissLabel = stringResource(R.string.profile_cancel),
        icon = MonAIIcons.PersonRemove,
        tone = MonAIAlertTone.Error,
        destructive = true,
    )
}
