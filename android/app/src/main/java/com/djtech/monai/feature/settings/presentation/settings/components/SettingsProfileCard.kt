package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.onClick
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAvatar
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.component.MonAITag
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsProfile

/** The user's photo, name, role and email; opens Edit profile. Placeholders until the user is cached. */
@Composable
internal fun SettingsProfileCard(
    profile: SettingsProfile?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val openLabel = stringResource(R.string.settings_profile_open)
    MonAICard(
        modifier
            .fillMaxWidth()
            .semantics { onClick(label = openLabel, action = null) },
        onClick = onClick,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3_5),
        ) {
            MonAIAvatar(
                profile?.initials.orEmpty(),
                size = MonAITheme.sizes.avatarXLarge,
                imageUrl = profile?.avatarUrl,
            )
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x0_5)) {
                if (profile == null) {
                    MonAISkeleton(height = MonAITheme.spacing.x5, modifier = Modifier.fillMaxWidth(NAME_SKELETON_WIDTH))
                    MonAISkeleton(height = MonAITheme.spacing.x3_5, modifier = Modifier.fillMaxWidth())
                } else {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
                    ) {
                        Text(
                            profile.name,
                            Modifier.weight(1f, fill = false),
                            style = MonAITheme.typography.titleLarge,
                            color = colors.textPrimary,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
                        )
                        profile.roleBadge?.let { MonAITag(it.uppercase()) }
                    }
                    Text(
                        profile.email,
                        style = MonAITheme.extendedTypography.bodyCompact,
                        color = colors.textTertiary,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                }
            }
            Icon(MonAIIcons.ChevronRight, null, tint = colors.textDisabled)
        }
    }
}

private const val NAME_SKELETON_WIDTH = 0.6f
