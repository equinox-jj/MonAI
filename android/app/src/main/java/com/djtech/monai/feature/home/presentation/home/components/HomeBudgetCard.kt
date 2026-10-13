package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIBudgetPromptCard
import com.djtech.monai.core.designsystem.component.MonAIBudgetRemaining
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIProgressBar
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.component.monthName
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import java.time.YearMonth
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
        BudgetCard.NotSet -> MonAIBudgetPromptCard(month, onClick, modifier)
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
    val statusColor = budget.status.color()
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
                stringResource(R.string.percent_value, percent),
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
            MonAIBudgetRemaining(budget.remaining, budget.status)
        }
    }
}
