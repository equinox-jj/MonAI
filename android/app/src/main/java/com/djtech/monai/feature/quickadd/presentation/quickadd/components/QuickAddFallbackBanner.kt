package com.djtech.monai.feature.quickadd.presentation.quickadd.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Shown when the AI couldn't help: the drafts are the phone's own, with gaps to check. */
@Composable
internal fun QuickAddFallbackBanner(modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    Row(
        modifier
            .fillMaxWidth()
            .background(colors.warningContainer, shape)
            .border(MonAITheme.sizes.border, colors.warningContainerBorder, shape)
            .padding(MonAITheme.spacing.x3)
            .semantics { liveRegion = LiveRegionMode.Polite },
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
    ) {
        Icon(MonAIIcons.HourglassTop, null, Modifier.size(MonAITheme.sizes.iconLg), tint = colors.warning)
        Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x0_5)) {
            Text(
                stringResource(R.string.quick_add_fallback_title),
                style = MonAITheme.typography.labelLarge,
                color = colors.onWarningContainer,
            )
            Text(
                stringResource(R.string.quick_add_fallback_body),
                style = MonAITheme.typography.bodySmall,
                color = colors.onWarningContainer,
            )
        }
    }
}
