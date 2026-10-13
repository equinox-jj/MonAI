package com.djtech.monai.feature.reports.presentation.report

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
import com.djtech.monai.feature.reports.presentation.report.model.ReportCategoryRow
import com.djtech.monai.feature.reports.presentation.report.model.ReportTotals
import java.time.YearMonth

/**
 * @param canGoNext [month] is before the current one; the report never shows a future month.
 * @param totals null until [month]'s report is cached; then [isLoading] or [loadError] says why.
 * @param categories expense categories, largest first.
 * @param budget null until [totals] is there, so the card doesn't show before the report.
 * @param loadError the fetch failed with nothing cached.
 */
@Immutable
data class ReportState(
    val month: YearMonth,
    val canGoNext: Boolean = false,
    val totals: ReportTotals? = null,
    val categories: List<ReportCategoryRow> = emptyList(),
    val budget: ReportBudgetCard? = null,
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
)

sealed interface ReportIntent {
    data object PreviousMonth : ReportIntent

    data object NextMonth : ReportIntent

    /** Sets or changes the shown month's budget. */
    data object OpenBudget : ReportIntent

    data object Retry : ReportIntent

    data object Back : ReportIntent
}

sealed interface ReportEffect {
    data object NavigateBack : ReportEffect

    data class OpenBudget(val month: YearMonth) : ReportEffect

    data class ShowMessage(val message: UiText) : ReportEffect
}
