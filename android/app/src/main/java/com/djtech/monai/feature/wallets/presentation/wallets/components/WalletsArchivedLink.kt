package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The dashed "Show N archived wallets" button under the list. */
@Composable
internal fun WalletsArchivedLink(count: Int, onClick: () -> Unit, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val radius = MonAITheme.radius.md
    val border = colors.borderStrong
    Row(
        modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.buttonMedium)
            .drawBehind {
                drawRoundRect(
                    color = border,
                    cornerRadius = CornerRadius(radius.toPx()),
                    style = Stroke(
                        width = 1.dp.toPx(),
                        pathEffect = PathEffect.dashPathEffect(floatArrayOf(4.dp.toPx(), 3.dp.toPx())),
                    ),
                )
            }
            .clip(RoundedCornerShape(radius))
            .clickable(role = Role.Button, onClick = onClick),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5, Alignment.CenterHorizontally),
    ) {
        Icon(
            MonAIIcons.Inventory2,
            contentDescription = null,
            modifier = Modifier.size(MonAITheme.sizes.iconLg),
            tint = colors.textSecondary,
        )
        Text(
            pluralStringResource(R.plurals.wallets_show_archived, count, count),
            style = MonAITheme.typography.labelLarge,
            color = colors.textSecondary,
        )
    }
}
