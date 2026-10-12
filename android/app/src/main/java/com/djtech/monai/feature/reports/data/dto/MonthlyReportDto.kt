package com.djtech.monai.feature.reports.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Months are `YYYY-MM`. */
@Serializable
data class MonthlyReportDto(
    @SerialName("month") val month: String,
    @SerialName("income_total") val incomeTotal: Long,
    @SerialName("expense_total") val expenseTotal: Long,
    @SerialName("net") val net: Long,
    @SerialName("previous") val previous: PreviousMonthTotalsDto,
    @SerialName("expense_change_percent") val expenseChangePercent: Double? = null,
    @SerialName("categories") val categories: List<CategoryBreakdownDto>,
)
