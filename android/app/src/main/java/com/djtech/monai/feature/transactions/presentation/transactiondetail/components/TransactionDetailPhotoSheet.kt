package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Where the receipt photo comes from: the camera or the gallery. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionDetailPhotoSheet(
    onTakePhoto: () -> Unit,
    onChoosePhoto: () -> Unit,
    onDismiss: () -> Unit,
) {
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.transaction_detail_receipt)) {
        SourceRow(MonAIIcons.PhotoCamera, stringResource(R.string.transaction_detail_photo_camera), onTakePhoto)
        SourceRow(MonAIIcons.PhotoLibrary, stringResource(R.string.transaction_detail_photo_gallery), onChoosePhoto)
        Text(
            stringResource(R.string.transaction_detail_receipt_add_meta),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}

@Composable
private fun SourceRow(icon: ImageVector, label: String, onClick: () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .heightIn(min = MonAITheme.sizes.settingsRow)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Icon(icon, null, Modifier.size(MonAITheme.sizes.icon), tint = MonAITheme.colors.accent)
        Text(label, style = MonAITheme.typography.bodyLarge, color = MonAITheme.colors.textPrimary)
    }
}
