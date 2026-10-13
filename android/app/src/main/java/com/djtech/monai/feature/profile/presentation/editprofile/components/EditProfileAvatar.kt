package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAvatar
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import kotlin.math.roundToInt

/**
 * The photo (or initials) ringed by upload progress, a camera badge, and Change / Remove below.
 * [uploadProgress] is 0..1 while uploading.
 */
@Composable
internal fun EditProfileAvatar(
    initials: String,
    avatarUrl: String?,
    uploadProgress: Float?,
    isRemoving: Boolean,
    onChangePhoto: () -> Unit,
    onRemovePhoto: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val isBusy = uploadProgress != null || isRemoving
    val changeLabel = stringResource(R.string.profile_change_photo_description)
    Column(
        modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Box(Modifier.size(RingSize), contentAlignment = Alignment.Center) {
            when {
                uploadProgress != null -> CircularProgressIndicator(
                    progress = { uploadProgress },
                    modifier = Modifier.size(RingSize),
                    color = colors.accent,
                    trackColor = colors.border,
                    strokeWidth = RingWidth,
                )

                isRemoving -> CircularProgressIndicator(
                    Modifier.size(RingSize),
                    color = colors.accent,
                    trackColor = colors.border,
                    strokeWidth = RingWidth,
                )
            }
            MonAIAvatar(initials, size = AvatarSize, imageUrl = avatarUrl)
            Box(
                Modifier
                    .align(Alignment.BottomEnd)
                    .size(BadgeSize)
                    .clip(CircleShape)
                    .background(colors.primary)
                    .border(BadgeBorder, colors.surface, CircleShape)
                    .clickable(enabled = !isBusy, onClick = onChangePhoto)
                    .semantics {
                        contentDescription = changeLabel
                        role = Role.Button
                    },
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    MonAIIcons.PhotoCamera,
                    null,
                    Modifier.size(MonAITheme.sizes.iconMd),
                    tint = colors.onPrimary,
                )
            }
        }
        if (uploadProgress != null) {
            Text(
                stringResource(R.string.profile_uploading, (uploadProgress * 100).roundToInt()),
                style = MonAITheme.typography.bodySmall,
                color = colors.textSecondary,
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            MonAIButton(
                stringResource(R.string.profile_change_photo),
                onClick = onChangePhoto,
                variant = MonAIButtonVariant.Tonal,
                size = MonAIButtonSize.Small,
                leadingIcon = MonAIIcons.PhotoLibrary,
                enabled = !isBusy,
            )
            if (avatarUrl != null) {
                MonAIButton(
                    stringResource(R.string.profile_remove_photo),
                    onClick = onRemovePhoto,
                    variant = MonAIButtonVariant.Outlined,
                    size = MonAIButtonSize.Small,
                    enabled = !isBusy,
                )
            }
        }
        Text(
            stringResource(R.string.profile_photo_note),
            Modifier.padding(horizontal = MonAITheme.spacing.x6),
            style = MonAITheme.typography.bodySmall,
            color = colors.textTertiary,
            textAlign = TextAlign.Center,
        )
    }
}

private val RingSize = 112.dp
private val RingWidth = 4.dp
private val AvatarSize = 96.dp
private val BadgeSize = 36.dp
private val BadgeBorder = 3.dp
