package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
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
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Camera, gallery or remove, with what happens to the photo's details. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun EditProfilePhotoSheet(
    hasPhoto: Boolean,
    onTakePhoto: () -> Unit,
    onChooseFromGallery: () -> Unit,
    onRemove: () -> Unit,
    onDismiss: () -> Unit,
) {
    val colors = MonAITheme.colors
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.profile_photo_title)) {
        SourceRow(
            MonAIIcons.PhotoCamera,
            stringResource(R.string.profile_photo_camera),
            stringResource(R.string.profile_photo_camera_note),
            onClick = onTakePhoto,
        )
        SourceRow(
            MonAIIcons.PhotoLibrary,
            stringResource(R.string.profile_photo_gallery),
            stringResource(R.string.profile_photo_gallery_note),
            onClick = onChooseFromGallery,
        )
        if (hasPhoto) {
            SourceRow(
                MonAIIcons.Delete,
                stringResource(R.string.profile_photo_remove),
                stringResource(R.string.profile_photo_remove_note),
                onClick = onRemove,
                tint = colors.errorText,
                showChevron = false,
            )
        }
        Row(
            Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(MonAITheme.radius.md))
                .background(colors.surfaceSunken)
                .padding(MonAITheme.spacing.x3),
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Icon(
                MonAIIcons.Shield,
                null,
                Modifier.size(MonAITheme.sizes.iconMd),
                tint = colors.success,
            )
            Text(
                stringResource(R.string.profile_photo_privacy),
                style = MonAITheme.typography.bodySmall,
                color = colors.textSecondary,
            )
        }
        MonAIButton(
            stringResource(R.string.profile_cancel),
            onClick = onDismiss,
            modifier = Modifier.fillMaxWidth(),
            variant = MonAIButtonVariant.Text,
        )
    }
}

@Composable
private fun SourceRow(
    icon: ImageVector,
    title: String,
    subtitle: String,
    onClick: () -> Unit,
    tint: Color = MonAITheme.colors.accent,
    showChevron: Boolean = true,
) {
    val colors = MonAITheme.colors
    Row(
        Modifier
            .fillMaxWidth()
            .heightIn(min = MonAITheme.sizes.pickerOption)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x1),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Box(
            Modifier
                .size(MonAITheme.sizes.avatarMedium)
                .clip(CircleShape)
                .background(colors.primaryContainer),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                icon,
                null,
                Modifier.size(MonAITheme.sizes.iconLg),
                tint = tint,
            )
        }
        Column(Modifier.weight(1f)) {
            Text(
                title,
                style = MonAITheme.typography.titleSmall,
                color = if (tint == colors.errorText) colors.errorText else colors.textPrimary,
            )
            Text(subtitle, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
        }
        if (showChevron) Icon(MonAIIcons.ChevronRight, null, tint = colors.textDisabled)
    }
}
