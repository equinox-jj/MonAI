package com.djtech.monai.feature.settings.presentation.manageproviders.components

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
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIMonogram
import com.djtech.monai.core.designsystem.component.MonAITag
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderRow
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderStatus

/** Logo, name with its status, type and aliases; a lock for system providers. */
@Composable
internal fun ManageProvidersRow(
    row: ProviderRow,
    canEdit: Boolean,
    onOpen: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val editLabel = stringResource(R.string.providers_edit, row.name)
    Row(
        modifier
            .fillMaxWidth()
            .heightIn(min = MonAITheme.sizes.listRowMin)
            .clickable(enabled = canEdit, role = Role.Button, onClick = onOpen)
            .semantics { if (canEdit) contentDescription = editLabel }
            .padding(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Row(
            Modifier
                .weight(1f)
                .alpha(if (row.status == ProviderStatus.INACTIVE) INACTIVE_ALPHA else 1f),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            ProviderLogo(row.monogram, row.logoUrl)
            Column(Modifier.weight(1f)) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
                ) {
                    Text(
                        row.name,
                        Modifier.weight(1f, fill = false),
                        style = MonAITheme.typography.titleSmall,
                        color = colors.textPrimary,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                    StatusTag(row.status)
                }
                Text(
                    listOf(row.type.label(), row.aliases).filter(String::isNotEmpty).joinToString(" · "),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }
        when {
            row.status == ProviderStatus.SYSTEM -> {
                val locked = stringResource(R.string.providers_locked)
                Icon(
                    MonAIIcons.Lock,
                    null,
                    Modifier
                        .size(MonAITheme.sizes.iconLg)
                        .semantics { contentDescription = locked },
                    tint = colors.textDisabled,
                )
            }

            canEdit -> Icon(MonAIIcons.ChevronRight, null, tint = colors.textDisabled)
        }
    }
}

/** The provider's logo, or its monogram while there is none or it fails to load. */
@Composable
internal fun ProviderLogo(monogram: String, logoUrl: String?, modifier: Modifier = Modifier) {
    val size = MonAITheme.sizes.avatarMedium
    Box(modifier.size(size), contentAlignment = Alignment.Center) {
        MonAIMonogram(
            monogram,
            containerColor = MonAITheme.colors.primaryContainer,
            contentColor = MonAITheme.colors.accent,
            size = size,
        )
        if (logoUrl != null) {
            AsyncImage(
                model = logoUrl,
                contentDescription = null,
                modifier = Modifier
                    .size(size)
                    .clip(CircleShape),
                contentScale = ContentScale.Fit,
            )
        }
    }
}

@Composable
private fun StatusTag(status: ProviderStatus) {
    val colors = MonAITheme.colors
    when (status) {
        ProviderStatus.SYSTEM -> MonAITag(stringResource(R.string.providers_badge_system).uppercase())
        ProviderStatus.ACTIVE -> MonAITag(
            stringResource(R.string.providers_badge_active).uppercase(),
            containerColor = colors.incomeContainer,
            contentColor = colors.successText,
        )

        ProviderStatus.INACTIVE -> MonAITag(
            stringResource(R.string.providers_badge_inactive).uppercase(),
            containerColor = colors.surfaceSunken,
            contentColor = colors.textSecondary,
        )
    }
}

private const val INACTIVE_ALPHA = 0.5f
