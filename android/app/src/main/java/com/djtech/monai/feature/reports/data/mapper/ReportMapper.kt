package com.djtech.monai.feature.reports.data.mapper

import com.djtech.monai.core.common.time.toYearMonthOrNull
import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.PreviousMonthTotals
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.reports.data.dto.CategoryBreakdownDto
import com.djtech.monai.feature.reports.data.dto.MonthlyReportDto
import com.djtech.monai.feature.reports.data.dto.PreviousMonthTotalsDto
import com.djtech.monai.feature.reports.domain.model.ReportError
import java.time.YearMonth

/** Throws on a malformed month; call it where the failure becomes a result. */
fun MonthlyReportDto.asModel(): MonthlyReport = MonthlyReport(
    month = month.toApiMonth(),
    incomeTotal = incomeTotal,
    expenseTotal = expenseTotal,
    net = net,
    previous = previous.asModel(),
    expenseChangePercent = expenseChangePercent,
    categories = categories.map(CategoryBreakdownDto::asModel),
)

private fun PreviousMonthTotalsDto.asModel() = PreviousMonthTotals(
    month = month.toApiMonth(),
    incomeTotal = incomeTotal,
    expenseTotal = expenseTotal,
)

private fun CategoryBreakdownDto.asModel() = CategoryBreakdown(
    categoryId = categoryId,
    name = name,
    icon = icon,
    color = color,
    amount = amount,
    sharePercent = sharePercent,
    previousAmount = previousAmount,
    changePercent = changePercent,
)

private fun String.toApiMonth(): YearMonth =
    requireNotNull(toYearMonthOrNull()) { "Not a YYYY-MM month: $this" }

// The month is always well formed, so a read only fails offline or unexpectedly.
fun ApiError.toReportError(): ReportError = when (this) {
    ApiError.Network -> ReportError.Network
    is ApiError.Http, is ApiError.Unknown -> ReportError.Unexpected
}
