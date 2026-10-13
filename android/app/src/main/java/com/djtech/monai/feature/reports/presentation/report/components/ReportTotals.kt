package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIGradientCard
import com.djtech.monai.core.designsystem.component.MonAIPill
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.component.arrowIcon
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.component.shortMonthName
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.reports.presentation.report.model.ExpenseComparison
import com.djtech.monai.feature.reports.presentation.report.model.ReportTotals
import com.djtech.monai.feature.reports.presentation.report.model.Trend
import kotlin.math.absoluteValue

/** Income and expense side by side, then the net on the brand gradient with the month-on-month chip. */
@Composable
internal fun ReportTotals(totals: ReportTotals, modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
        Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
            TotalTile(
                stringResource(R.string.report_income),
                formatRupiahSigned(totals.income, MoneySign.Positive),
                MoneyDirection.Income,
                Modifier.weight(1f),
            )
            TotalTile(
                stringResource(R.string.report_expense),
                formatRupiahSigned(totals.expense, MoneySign.Negative),
                MoneyDirection.Expense,
                Modifier.weight(1f),
            )
        }
        NetCard(totals.net, totals.comparison)
    }
}

@Composable
private fun TotalTile(
    label: String,
    amount: String,
    direction: MoneyDirection,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val container = if (direction == MoneyDirection.Income) colors.incomeContainer else colors.expenseContainer
    MonAICard(
        modifier,
        contentPadding = PaddingValues(MonAITheme.spacing.x3_5),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            Box(
                Modifier
                    .size(24.dp)
                    .clip(CircleShape)
                    .background(container),
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    direction.arrowIcon(),
                    null,
                    Modifier.size(MonAITheme.sizes.iconSm),
                    tint = direction.color(),
                )
            }
            Text(label, style = MonAITheme.typography.bodySmall, color = colors.textSecondary)
        }
        Text(
            amount,
            style = MonAITheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold).tabular(),
            color = direction.color(),
            maxLines = 1,
        )
    }
}

@Composable
private fun NetCard(net: Long, comparison: ExpenseComparison?) {
    val colors = MonAITheme.colors
    MonAIGradientCard(
        Modifier.fillMaxWidth(),
        cornerRadius = MonAITheme.radius.lg,
        contentPadding = PaddingValues(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x3_5),
        elevated = false,
        decorated = false,
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.report_net),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.onGradientMuted,
                )
                Text(
                    formatRupiahSigned(net.absoluteValue, if (net < 0) MoneySign.Negative else MoneySign.Positive),
                    style = MonAITheme.typography.headlineMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                    color = colors.onPrimary,
                    maxLines = 1,
                )
            }
            if (comparison != null) MonAIPill(comparison.text())
        }
    }
}

@Composable
private fun ExpenseComparison.text(): String {
    val previous = previousMonth.shortMonthName()
    return when (trend) {
        Trend.LESS -> stringResource(R.string.report_spent_less, percent, previous)
        Trend.MORE -> stringResource(R.string.report_spent_more, percent, previous)
        Trend.SAME -> stringResource(R.string.report_spent_same, previous)
    }
}
