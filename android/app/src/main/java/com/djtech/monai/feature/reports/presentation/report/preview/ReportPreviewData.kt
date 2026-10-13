package com.djtech.monai.feature.reports.presentation.report.preview

import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.feature.reports.presentation.report.ReportState
import com.djtech.monai.feature.reports.presentation.report.model.CategoryChange
import com.djtech.monai.feature.reports.presentation.report.model.ExpenseComparison
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
import com.djtech.monai.feature.reports.presentation.report.model.ReportCategoryRow
import com.djtech.monai.feature.reports.presentation.report.model.ReportTotals
import com.djtech.monai.feature.reports.presentation.report.model.Trend
import java.time.YearMonth
import kotlin.math.absoluteValue

internal object ReportPreviewData {
    private val october = YearMonth.of(2026, 10)

    private fun row(
        name: String,
        icon: String,
        color: String,
        amount: Long,
        share: Double,
        /** Percent against September; negative is less. */
        change: Int,
    ) = ReportCategoryRow(
        categoryId = name.lowercase(),
        name = name,
        icon = icon,
        color = color,
        amount = amount,
        sharePercent = share,
        change = CategoryChange(change.absoluteValue, if (change > 0) Trend.MORE else Trend.LESS),
    )

    val state = ReportState(
        month = october,
        canGoNext = false,
        totals = ReportTotals(
            income = 8_500_000,
            expense = 2_415_000,
            net = 6_085_000,
            comparison = ExpenseComparison(10, Trend.LESS, october.minusMonths(1)),
        ),
        categories = listOf(
            row(
                name = "Food",
                icon = "restaurant",
                color = "#F97316",
                amount = 865_000,
                share = 35.8,
                change = -5,
            ),
            row(
                name = "Bills",
                icon = "receipt_long",
                color = "#8B5CF6",
                amount = 610_000,
                share = 25.3,
                change = -5,
            ),
            row(
                name = "Transport",
                icon = "directions_car",
                color = "#0EA5E9",
                amount = 420_000,
                share = 17.4,
                change = 11,
            ),
            row(
                name = "Shopping",
                icon = "shopping_bag",
                color = "#EC4899",
                amount = 310_000,
                share = 12.8,
                change = -40,
            ),
            row(
                name = "Entertainment",
                icon = "movie",
                color = "#F59E0B",
                amount = 135_000,
                share = 5.6,
                change = -10,
            ),
            row(
                name = "Other",
                icon = "category",
                color = "#64748B",
                amount = 75_000,
                share = 3.1,
                change = -6,
            ),
        ),
        budget = ReportBudgetCard.Set(
            Budget(
                month = october,
                limitAmount = 3_000_000,
                spent = 2_415_000,
                remaining = 585_000,
                progressPercent = 80.5,
                status = BudgetStatus.WARNING,
            ),
        ),
        isLoading = false,
    )
}
