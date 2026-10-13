package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.BudgetStatus
import java.time.YearMonth
import kotlin.math.absoluteValue

/** The progress color of a budget: brand on track, amber from 80%, red over the limit. */
@Composable
fun BudgetStatus.color(): Color = when (this) {
    BudgetStatus.OK -> MonAITheme.colors.accent
    BudgetStatus.WARNING -> MonAITheme.colors.warning
    BudgetStatus.EXCEEDED -> MonAITheme.colors.error
}

/** What's left of a budget (amber with a warning near the limit), or how far over it is. */
@Composable
fun MonAIBudgetRemaining(remaining: Long, status: BudgetStatus, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val (color, icon) = when (status) {
        BudgetStatus.OK -> colors.textSecondary to null
        BudgetStatus.WARNING -> colors.warning to MonAIIcons.Warning
        BudgetStatus.EXCEEDED -> colors.error to MonAIIcons.Error
    }
    val text = if (remaining < 0) {
        stringResource(R.string.budget_over, formatRupiah(remaining.absoluteValue))
    } else {
        stringResource(R.string.budget_left, formatRupiah(remaining))
    }
    Row(
        modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        if (icon != null) {
            Icon(
                icon,
                null,
                Modifier.size(MonAITheme.sizes.iconSm),
                tint = color,
            )
        }
        Text(
            text,
            style = MonAITheme.extendedTypography.bodyCompact.copy(fontWeight = FontWeight.SemiBold),
            color = color,
        )
    }
}

/** Dashed card asking to set [month]'s spending limit. */
@Composable
fun MonAIBudgetPromptCard(month: YearMonth, onClick: () -> Unit, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val radius = MonAITheme.radius.lg
    val dashColor = colors.primaryContainerBorder
    Row(
        modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(radius))
            .background(colors.surface)
            .drawBehind { drawDashedBorder(dashColor, radius.toPx()) }
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = spacing.x4, vertical = spacing.x3_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(spacing.x3),
    ) {
        Box(
            Modifier
                .size(MonAITheme.sizes.avatarMedium)
                .clip(CircleShape)
                .background(colors.primaryContainer),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                MonAIIcons.Savings,
                null,
                Modifier.size(MonAITheme.sizes.iconLg),
                tint = colors.accent,
            )
        }
        Column(Modifier.weight(1f)) {
            Text(
                stringResource(R.string.budget_empty_title, month.monthName()),
                style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                color = colors.textPrimary,
            )
            Text(
                stringResource(R.string.budget_empty_body),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
        Text(
            stringResource(R.string.budget_set),
            style = MonAITheme.typography.labelLarge,
            color = colors.accent,
        )
    }
}

private fun DrawScope.drawDashedBorder(color: Color, cornerRadius: Float) {
    val width = 1.dp.toPx()
    drawRoundRect(
        color = color,
        topLeft = Offset(width / 2, width / 2),
        size = Size(size.width - width, size.height - width),
        cornerRadius = CornerRadius(cornerRadius),
        style = Stroke(width = width, pathEffect = PathEffect.dashPathEffect(floatArrayOf(4.dp.toPx(), 3.dp.toPx()))),
    )
}
