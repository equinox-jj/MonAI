package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIBudgetPromptCard
import com.djtech.monai.core.designsystem.component.MonAIBudgetRemaining
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIProgressBar
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
import java.time.YearMonth
import kotlin.math.floor

/** The month's budget progress with "Change", or the prompt to set one. Either opens the budget. */
@Composable
internal fun ReportBudgetCard(
    card: ReportBudgetCard,
    month: YearMonth,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    when (card) {
        ReportBudgetCard.NotSet -> MonAIBudgetPromptCard(month, onClick, modifier)
        is ReportBudgetCard.Set -> {
            val colors = MonAITheme.colors
            val budget = card.budget
            val statusColor = budget.status.color()
            MonAICard(modifier.fillMaxWidth(), onClick = onClick) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.report_budget_title),
                        Modifier.weight(1f),
                        style = MonAITheme.typography.titleMedium,
                    )
                    Text(
                        stringResource(R.string.report_budget_change),
                        style = MonAITheme.typography.labelLarge,
                        color = colors.accent,
                    )
                }
                MonAIProgressBar((budget.progressPercent / 100).toFloat(), color = statusColor)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(
                            R.string.report_budget_progress,
                            // Rounded down, so it never reads 100% before the limit is reached.
                            floor(budget.progressPercent).toInt(),
                            formatRupiah(budget.limitAmount),
                        ),
                        Modifier.weight(1f),
                        style = MonAITheme.extendedTypography.bodyCompact.tabular(),
                        color = colors.textSecondary,
                    )
                    MonAIBudgetRemaining(budget.remaining, budget.status)
                }
            }
        }
    }
}
