package com.djtech.monai.feature.receipt.presentation.scanreceipt.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** No text on the photo: tips for a better one, then retake or type it in. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun ScanReceiptNoText(onRetake: () -> Unit, onManual: () -> Unit) {
    val colors = MonAITheme.colors
    MonAIBottomSheet(onDismissRequest = onRetake) {
        Icon(
            MonAIIcons.ReceiptLong,
            null,
            Modifier
                .size(MonAITheme.sizes.avatarXLarge - MonAITheme.spacing.x2)
                .background(colors.errorContainer, CircleShape)
                .padding(MonAITheme.spacing.x3_5),
            tint = colors.error,
        )
        Text(
            stringResource(R.string.scan_no_text_title),
            style = MonAITheme.typography.headlineSmall,
            color = colors.textPrimary,
        )
        Text(
            stringResource(R.string.scan_no_text_body),
            style = MonAITheme.typography.bodyMedium,
            color = colors.textSecondary,
        )
        Column(
            Modifier
                .fillMaxWidth()
                .background(colors.background, RoundedCornerShape(MonAITheme.radius.md))
                .padding(MonAITheme.spacing.x3_5),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
        ) {
            Tip(MonAIIcons.LightMode, stringResource(R.string.scan_tip_light))
            Tip(MonAIIcons.CropFree, stringResource(R.string.scan_tip_flat))
            Tip(MonAIIcons.CenterFocusStrong, stringResource(R.string.scan_tip_still))
        }
        MonAIButton(
            stringResource(R.string.scan_retake),
            onClick = onRetake,
            modifier = Modifier.fillMaxWidth(),
            leadingIcon = MonAIIcons.PhotoCamera,
        )
        MonAIButton(
            stringResource(R.string.scan_manual),
            onClick = onManual,
            modifier = Modifier.fillMaxWidth(),
            variant = MonAIButtonVariant.Outlined,
            size = MonAIButtonSize.Medium,
            leadingIcon = MonAIIcons.Edit,
        )
    }
}

@Composable
private fun Tip(icon: ImageVector, text: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
    ) {
        Icon(icon, null, Modifier.size(MonAITheme.sizes.iconMd), tint = MonAITheme.colors.accent)
        Text(text, style = MonAITheme.typography.bodySmall, color = MonAITheme.colors.iconStrong)
    }
}
