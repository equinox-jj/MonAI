package com.djtech.monai.feature.home.presentation.home.components

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
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIProgressBar
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import java.time.YearMonth
import kotlin.math.absoluteValue
import kotlin.math.floor

@Composable
internal fun HomeBudgetCard(
    card: BudgetCard,
    month: YearMonth,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    when (card) {
        is BudgetCard.Set -> BudgetProgressCard(card, month, onClick, modifier)
        BudgetCard.NotSet -> BudgetPromptCard(month, onClick, modifier)
    }
}

@Composable
private fun BudgetProgressCard(
    card: BudgetCard.Set,
    month: YearMonth,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val budget = card.budget
    // Rounded down, so the bar never reads 100% before the limit is reached.
    val percent = floor(budget.progressPercent).toInt()
    val statusColor = when (budget.status) {
        BudgetStatus.OK -> colors.accent
        BudgetStatus.WARNING -> colors.warning
        BudgetStatus.EXCEEDED -> colors.error
    }
    val title = stringResource(R.string.home_budget_title, month.monthName())
    MonAICard(modifier.fillMaxWidth(), onClick = onClick) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text(title, style = MonAITheme.typography.titleMedium)
                Text(
                    if (card.daysLeft == 0) {
                        stringResource(R.string.home_budget_last_day)
                    } else {
                        pluralStringResource(R.plurals.home_budget_days_left, card.daysLeft, card.daysLeft)
                    },
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
            }
            Text(
                stringResource(R.string.home_budget_percent, percent),
                style = MonAITheme.extendedTypography.amountMedium,
                color = statusColor,
            )
        }
        MonAIProgressBar((budget.progressPercent / 100).toFloat(), color = statusColor)
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                stringResource(
                    R.string.home_budget_progress,
                    formatRupiah(budget.spent),
                    formatRupiah(budget.limitAmount),
                ),
                Modifier.weight(1f),
                style = MonAITheme.extendedTypography.bodyCompact,
                color = colors.textSecondary,
            )
            BudgetRemaining(budget.remaining, budget.status)
        }
    }
}

/** What's left (amber with a warning near the limit), or how far over it is. */
@Composable
private fun BudgetRemaining(remaining: Long, status: BudgetStatus) {
    val colors = MonAITheme.colors
    val (color, icon) = when (status) {
        BudgetStatus.OK -> colors.textSecondary to null
        BudgetStatus.WARNING -> colors.warning to MonAIIcons.Warning
        BudgetStatus.EXCEEDED -> colors.error to MonAIIcons.Error
    }
    val text = if (remaining < 0) {
        stringResource(R.string.home_budget_over, formatRupiah(remaining.absoluteValue))
    } else {
        stringResource(R.string.home_budget_left, formatRupiah(remaining))
    }
    Row(
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

/** Dashed card asking to set the month's limit. */
@Composable
private fun BudgetPromptCard(month: YearMonth, onClick: () -> Unit, modifier: Modifier = Modifier) {
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
                stringResource(R.string.home_budget_empty_title, month.monthName()),
                style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                color = colors.textPrimary,
            )
            Text(
                stringResource(R.string.home_budget_empty_body),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
        Text(
            stringResource(R.string.home_budget_set),
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
