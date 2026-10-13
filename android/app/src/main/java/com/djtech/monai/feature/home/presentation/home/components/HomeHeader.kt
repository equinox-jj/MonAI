package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAvatar
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAIIconButtonStyle
import com.djtech.monai.core.designsystem.component.MonAIPillField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeIntent
import com.djtech.monai.feature.home.presentation.home.model.Greeting

/** Greeting and name, then search (hidden while there's nothing to search) and the avatar. */
@Composable
internal fun HomeHeader(
    greeting: Greeting,
    userName: String,
    initials: String,
    avatarUrl: String?,
    onIntent: (HomeIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val profileLabel = stringResource(R.string.home_profile)
    Row(
        modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Column(Modifier.weight(1f)) {
            Text(greeting.text(), style = MonAITheme.typography.bodyMedium, color = colors.textSecondary)
            Text(
                userName,
                style = MonAITheme.typography.headlineSmall,
                color = colors.textPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }
        if (greeting != Greeting.WELCOME) {
            MonAIIconButton(
                MonAIIcons.Search,
                stringResource(R.string.home_search),
                onClick = { onIntent(HomeIntent.Open(HomeDestination.Search)) },
                style = MonAIIconButtonStyle.Surface,
                tint = colors.textSecondary,
            )
        }
        MonAIAvatar(
            initials,
            Modifier
                .clip(CircleShape)
                .clickable(role = Role.Button) { onIntent(HomeIntent.Open(HomeDestination.Settings)) }
                .semantics { contentDescription = profileLabel },
            imageUrl = avatarUrl,
        )
    }
}

/** The natural-language entry and the receipt scanner, with a hint below. */
@Composable
internal fun HomeQuickAdd(onIntent: (HomeIntent) -> Unit, modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x2),
        ) {
            MonAIPillField(
                text = stringResource(R.string.home_quick_add_example),
                leadingIcon = MonAIIcons.AutoAwesome,
                onClick = { onIntent(HomeIntent.Open(HomeDestination.QuickAdd)) },
                modifier = Modifier.weight(1f),
                leadingIconTint = MonAITheme.colors.accent,
                height = MonAITheme.sizes.quickAddField,
            )
            MonAIIconButton(
                MonAIIcons.DocumentScanner,
                stringResource(R.string.home_scan_receipt),
                onClick = { onIntent(HomeIntent.Open(HomeDestination.ScanReceipt)) },
                style = MonAIIconButtonStyle.Tonal,
                size = MonAITheme.sizes.quickAddField,
            )
        }
        Text(
            stringResource(R.string.home_quick_add_helper),
            Modifier.padding(start = spacing.x4),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}
