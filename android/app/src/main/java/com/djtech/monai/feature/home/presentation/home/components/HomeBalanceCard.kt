package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAIGradientCard
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAIPill
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeIntent
import com.djtech.monai.feature.home.presentation.home.HomeState
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import kotlin.math.absoluteValue
import kotlin.math.roundToInt

/**
 * The total-balance hero: total, the month's income and expense, and the change from last month.
 * With at most one wallet it prompts to add more, as on the first run.
 */
@Composable
internal fun HomeBalanceCard(
    state: HomeState,
    onIntent: (HomeIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val summary = state.summary
    val hiddenAmount = stringResource(R.string.home_hidden_amount)
    MonAIGradientCard(modifier.fillMaxWidth()) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                pluralStringResource(R.plurals.home_total_balance, state.wallets.size, state.wallets.size),
                Modifier.weight(1f),
                style = MonAITheme.typography.labelLarge.copy(fontWeight = FontWeight.Medium),
                color = colors.onGradientMuted,
            )
            // The 44dp target overhangs the label's line instead of making the row taller.
            Box(Modifier.size(spacing.x5)) {
                MonAIIconButton(
                    if (state.isBalanceHidden) MonAIIcons.VisibilityOff else MonAIIcons.Visibility,
                    stringResource(
                        if (state.isBalanceHidden) R.string.home_show_balance else R.string.home_hide_balance,
                    ),
                    onClick = { onIntent(HomeIntent.ToggleBalanceVisibility) },
                    modifier = Modifier
                        .wrapContentSize(unbounded = true)
                        .offset(x = spacing.x2_5),
                    tint = Color.White,
                    iconSize = MonAITheme.sizes.iconXl - spacing.x1_5,
                )
            }
        }
        Text(
            if (state.isBalanceHidden) hiddenAmount else formatRupiah(state.totalBalance),
            style = MonAITheme.typography.displayMedium.tabular(),
        )
        if (summary != null && (summary.incomeTotal > 0 || summary.expenseTotal > 0)) {
            Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
                MonthTotalTile(
                    label = stringResource(R.string.home_income_month, state.month.shortMonthName()),
                    amount = maskedCompact("+", summary.incomeTotal, state.isBalanceHidden),
                    icon = MonAIIcons.SouthWest,
                    iconContainer = colors.highlight,
                    iconTint = colors.onHighlight,
                    modifier = Modifier.weight(1f),
                )
                MonthTotalTile(
                    label = stringResource(R.string.home_expense_month, state.month.shortMonthName()),
                    amount = maskedCompact("−", summary.expenseTotal, state.isBalanceHidden),
                    icon = MonAIIcons.NorthEast,
                    iconContainer = Color.White,
                    iconTint = colors.expense,
                    modifier = Modifier.weight(1f),
                )
            }
        }
        summary?.changeText()?.let { MonAIPill(it) }
        if (state.wallets.size <= 1) {
            MonAIPill(
                stringResource(R.string.home_add_wallets),
                Modifier
                    .padding(top = spacing.x1_5)
                    .clip(CircleShape)
                    .clickable(role = Role.Button) { onIntent(HomeIntent.Open(HomeDestination.AddWallet)) }
                    .heightIn(min = MonAITheme.sizes.buttonSmall),
                icon = MonAIIcons.Add,
            )
        }
    }
}

@Composable
private fun maskedCompact(sign: String, amount: Long, hidden: Boolean): String =
    if (hidden) stringResource(R.string.home_hidden_amount_short) else sign + formatRupiahCompact(amount)

/** `10% less spent than September`; null when last month had nothing to compare with. */
@Composable
private fun MonthSummary.changeText(): String? {
    val change = expenseChangePercent ?: return null
    val previous = previousMonth.monthName()
    val percent = change.absoluteValue.roundToInt()
    return when {
        percent == 0 -> stringResource(R.string.home_spent_same, previous)
        change < 0 -> stringResource(R.string.home_spent_less, percent, previous)
        else -> stringResource(R.string.home_spent_more, percent, previous)
    }
}

@Composable
private fun MonthTotalTile(
    label: String,
    amount: String,
    icon: ImageVector,
    iconContainer: Color,
    iconTint: Color,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Row(
        modifier
            .clip(RoundedCornerShape(MonAITheme.radius.lg))
            .background(Color.White.copy(alpha = 0.12f))
            .padding(horizontal = spacing.x3, vertical = spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
    ) {
        Box(
            Modifier
                .size(MonAITheme.sizes.avatarSmall)
                .clip(CircleShape)
                .background(iconContainer),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                icon,
                null,
                Modifier.size(MonAITheme.sizes.iconMd),
                tint = iconTint,
            )
        }
        Column {
            Text(
                label,
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.onGradientMuted,
                maxLines = 1,
            )
            Text(
                amount,
                style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold).tabular(),
                maxLines = 1,
            )
        }
    }
}
