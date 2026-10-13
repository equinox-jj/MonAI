package com.djtech.monai.feature.reports.presentation.report.mapper

import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.feature.reports.presentation.report.model.CategoryChange
import com.djtech.monai.feature.reports.presentation.report.model.ExpenseComparison
import com.djtech.monai.feature.reports.presentation.report.model.ReportCategoryRow
import com.djtech.monai.feature.reports.presentation.report.model.ReportTotals
import com.djtech.monai.feature.reports.presentation.report.model.Trend
import kotlin.math.absoluteValue
import kotlin.math.roundToInt

internal fun MonthlyReport.toTotals(): ReportTotals = ReportTotals(
    income = incomeTotal,
    expense = expenseTotal,
    net = net,
    comparison = expenseChangePercent?.let { change ->
        val (percent, trend) = change.toPercentAndTrend()
        ExpenseComparison(percent, trend, previous.month)
    },
)

internal fun CategoryBreakdown.toRow(): ReportCategoryRow = ReportCategoryRow(
    categoryId = categoryId,
    name = name,
    icon = icon,
    color = color,
    amount = amount,
    sharePercent = sharePercent,
    change = changePercent?.let { change ->
        val (percent, trend) = change.toPercentAndTrend()
        CategoryChange(percent, trend)
    },
)

// A change that rounds to 0% reads as the same, whichever way it went.
private fun Double.toPercentAndTrend(): Pair<Int, Trend> {
    val percent = absoluteValue.roundToInt()
    val trend = when {
        percent == 0 -> Trend.SAME
        this < 0 -> Trend.LESS
        else -> Trend.MORE
    }
    return percent to trend
}
