package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The last searches as chips; tapping one searches it again. */
@OptIn(ExperimentalLayoutApi::class)
@Composable
internal fun SearchRecent(
    searches: List<String>,
    onUse: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        Text(
            stringResource(R.string.transaction_search_recent),
            style = MonAITheme.typography.labelMedium,
            color = colors.textTertiary,
        )
        FlowRow(
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            searches.forEach { search ->
                Row(
                    Modifier
                        .height(MonAITheme.sizes.filterChip)
                        .clip(CircleShape)
                        .background(colors.surface)
                        .border(MonAITheme.sizes.border, colors.border, CircleShape)
                        .clickable(role = Role.Button) { onUse(search) }
                        .padding(horizontal = MonAITheme.spacing.x3),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
                ) {
                    Icon(
                        MonAIIcons.History,
                        null,
                        Modifier.size(MonAITheme.sizes.iconSm),
                        tint = colors.textDisabled,
                    )
                    Text(search, style = MonAITheme.extendedTypography.bodyCompact, color = colors.iconStrong)
                }
            }
        }
    }
}
