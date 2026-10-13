package com.djtech.monai.feature.reports.presentation.report.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.Budget
import java.time.YearMonth

/** The month's totals, rupiah. */
@Immutable
data class ReportTotals(
    val income: Long,
    val expense: Long,
    /** Negative when the month spent more than it earned. */
    val net: Long,
    /** Null when the previous month had no expenses to compare with. */
    val comparison: ExpenseComparison?,
)

/** This month's expense against [previousMonth]'s; [percent] is rounded and never negative. */
@Immutable
data class ExpenseComparison(
    val percent: Int,
    val trend: Trend,
    val previousMonth: YearMonth,
)

enum class Trend { LESS, SAME, MORE }

/** One expense category's line in the breakdown. */
@Immutable
data class ReportCategoryRow(
    val categoryId: String,
    val name: String,
    val icon: String?,
    val color: String?,
    val amount: Long,
    /** Of the month's expense, for the donut. */
    val sharePercent: Double,
    /** Null when the category had nothing the month before. */
    val change: CategoryChange?,
)

/** Against the previous month; [percent] is rounded and never negative. */
@Immutable
data class CategoryChange(val percent: Int, val trend: Trend)

@Immutable
sealed interface ReportBudgetCard {
    data class Set(val budget: Budget) : ReportBudgetCard

    data object NotSet : ReportBudgetCard
}
