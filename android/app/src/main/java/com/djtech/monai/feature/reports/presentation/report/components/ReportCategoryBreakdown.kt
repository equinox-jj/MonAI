package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.MonAIDonut
import com.djtech.monai.core.designsystem.component.monthName
import com.djtech.monai.core.designsystem.component.shortMonthName
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.reports.presentation.report.model.CategoryChange
import com.djtech.monai.feature.reports.presentation.report.model.ReportCategoryRow
import com.djtech.monai.feature.reports.presentation.report.model.Trend
import java.time.YearMonth
import kotlin.math.roundToInt

private val DonutSize = 200.dp
private val DonutStroke = 22.dp

/** "Spending by category": a donut of the month's expense, then each category with its change. */
@Composable
internal fun ReportCategoryBreakdown(
    categories: List<ReportCategoryRow>,
    expenseTotal: Long,
    month: YearMonth,
    modifier: Modifier = Modifier,
) {
    MonAICard(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4)) {
        Text(stringResource(R.string.report_breakdown_title), style = MonAITheme.typography.titleMedium)
        if (categories.isEmpty()) {
            NoSpending(month)
            return@MonAICard
        }
        BreakdownDonut(
            categories,
            expenseTotal,
            month,
            Modifier.align(Alignment.CenterHorizontally),
        )
        Column {
            val previous = month.minusMonths(1).shortMonthName()
            categories.forEach { row ->
                MonAIDivider()
                CategoryRow(row, previous)
            }
        }
    }
}

@Composable
private fun BreakdownDonut(
    categories: List<ReportCategoryRow>,
    expenseTotal: Long,
    month: YearMonth,
    modifier: Modifier = Modifier,
) {
    val dark = MonAITheme.colors.isDark
    val colors = remember(categories, dark) {
        categories.map { CategoryColors.content(CategoryColors.parse(it.color), dark) }
    }
    val shares = categories.map {
        stringResource(R.string.report_breakdown_share_description, it.name, it.sharePercent.roundToInt())
    }.joinToString(", ")
    val description = stringResource(R.string.report_breakdown_description, month.monthName(), shares)
    Box(modifier.size(DonutSize), contentAlignment = Alignment.Center) {
        MonAIDonut(
            categories.map { it.sharePercent.toFloat() },
            colors,
            DonutStroke,
            Modifier
                .fillMaxSize()
                .semantics { contentDescription = description },
        )
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                formatRupiahCompact(expenseTotal),
                style = MonAITheme.typography.headlineSmall.copy(fontWeight = FontWeight.Bold).tabular(),
            )
            Text(
                stringResource(R.string.report_breakdown_spent_in, month.monthName()),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
            )
        }
    }
}

@Composable
private fun CategoryRow(row: ReportCategoryRow, previousMonth: String) {
    val colors = MonAITheme.colors
    Row(
        Modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        MonAICategoryIcon(
            categoryIcon(row.icon),
            CategoryColors.parse(row.color),
            size = 36.dp,
            iconSize = MonAITheme.sizes.iconMd,
        )
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    row.name,
                    Modifier.weight(1f),
                    style = MonAITheme.typography.labelLarge,
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                Text(
                    formatRupiah(row.amount),
                    style = MonAITheme.typography.labelLarge.tabular(),
                    color = colors.textPrimary,
                )
            }
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.report_breakdown_share, row.sharePercent.roundToInt()),
                    Modifier.weight(1f),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
                row.change?.let { ChangeText(it, previousMonth) }
            }
        }
    }
}

/** `↓ 5% vs Sep` in green, `↑ 11% vs Sep` in red: less spending is the good direction. */
@Composable
private fun ChangeText(change: CategoryChange, previousMonth: String) {
    val colors = MonAITheme.colors
    val (text, spoken, color) = when (change.trend) {
        Trend.LESS -> Triple(
            stringResource(R.string.report_change_less, change.percent, previousMonth),
            stringResource(R.string.report_change_less_description, change.percent, previousMonth),
            colors.successText,
        )

        Trend.MORE -> Triple(
            stringResource(R.string.report_change_more, change.percent, previousMonth),
            stringResource(R.string.report_change_more_description, change.percent, previousMonth),
            colors.errorText,
        )

        Trend.SAME -> stringResource(R.string.report_change_same, previousMonth).let {
            Triple(it, it, colors.textTertiary)
        }
    }
    Text(
        text,
        Modifier.clearAndSetSemantics { contentDescription = spoken },
        style = MonAITheme.typography.labelMedium.tabular(),
        color = color,
    )
}

@Composable
private fun NoSpending(month: YearMonth) {
    Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
        Text(
            stringResource(R.string.report_no_spending_title, month.monthName()),
            style = MonAITheme.typography.bodyMedium.copy(fontWeight = FontWeight.SemiBold),
            color = MonAITheme.colors.textPrimary,
        )
        Text(
            stringResource(R.string.report_no_spending_body),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}
