package com.djtech.monai.feature.settings.presentation.providerform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.providerform.model.ProviderFormDialog

/** Confirms deactivating or deleting [name], listing what stays as it is. */
@Composable
internal fun ProviderFormDialogs(
    dialog: ProviderFormDialog?,
    name: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    val colors = MonAITheme.colors
    when (dialog) {
        null -> Unit
        ProviderFormDialog.Deactivate -> MonAIAlertDialog(
            title = stringResource(R.string.provider_deactivate_title, name),
            message = stringResource(R.string.provider_deactivate_message, name),
            confirmLabel = stringResource(R.string.provider_deactivate_confirm),
            onConfirm = onConfirm,
            onDismissRequest = onDismiss,
            dismissLabel = stringResource(R.string.provider_cancel),
            icon = MonAIIcons.VisibilityOff,
            tone = MonAIAlertTone.Warning,
        ) {
            Facts(
                listOf(
                    MonAIIcons.CheckCircle to stringResource(R.string.provider_deactivate_keeps),
                    MonAIIcons.CheckCircle to stringResource(R.string.provider_deactivate_undo),
                ),
                tint = colors.success,
            )
        }

        ProviderFormDialog.Delete -> MonAIAlertDialog(
            title = stringResource(R.string.provider_delete_title, name),
            message = stringResource(R.string.provider_delete_message, name),
            confirmLabel = stringResource(R.string.provider_delete_confirm),
            onConfirm = onConfirm,
            onDismissRequest = onDismiss,
            dismissLabel = stringResource(R.string.provider_cancel),
            icon = MonAIIcons.Delete,
            tone = MonAIAlertTone.Error,
            destructive = true,
        ) {
            Facts(
                listOf(
                    MonAIIcons.Sell to stringResource(R.string.provider_delete_aliases),
                    MonAIIcons.Image to stringResource(R.string.provider_delete_logo),
                ),
                tint = colors.textSecondary,
            )
        }
    }
}

@Composable
private fun Facts(facts: List<Pair<ImageVector, String>>, tint: Color) {
    val colors = MonAITheme.colors
    Column(
        Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .background(colors.surfaceSunken)
            .padding(MonAITheme.spacing.x3),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        facts.forEach { (icon, text) ->
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
            ) {
                Icon(
                    icon,
                    null,
                    Modifier.size(MonAITheme.sizes.iconMd),
                    tint = tint,
                )
                Text(text, style = MonAITheme.extendedTypography.bodyCompact, color = colors.textSecondary)
            }
        }
    }
}
