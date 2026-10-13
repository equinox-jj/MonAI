package com.djtech.monai.feature.quickadd.presentation.quickaddreview.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** One bar per draft (done, current, ahead) and the phrase the drafts came from. */
@Composable
internal fun QuickAddReviewProgress(
    phrase: String,
    index: Int,
    total: Int,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4)) {
        Row(
            Modifier.clearAndSetSemantics {},
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            repeat(total) { bar ->
                val color = when {
                    bar < index -> colors.primary
                    bar == index -> colors.primaryContainerBorder
                    else -> colors.border
                }
                Row(
                    Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(color, RoundedCornerShape(2.dp)),
                ) {}
            }
        }
        Row(
            Modifier
                .fillMaxWidth()
                .background(colors.background, RoundedCornerShape(MonAITheme.radius.md))
                .padding(horizontal = MonAITheme.spacing.x3, vertical = MonAITheme.spacing.x2_5),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Icon(MonAIIcons.AutoAwesome, null, Modifier.size(MonAITheme.sizes.iconMd), tint = colors.accent)
            Text(
                stringResource(R.string.quick_add_review_from, phrase),
                style = MonAITheme.typography.bodySmall,
                color = colors.textSecondary,
            )
        }
    }
}
