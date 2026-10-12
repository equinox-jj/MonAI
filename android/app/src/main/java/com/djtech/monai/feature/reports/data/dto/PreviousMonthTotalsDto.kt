package com.djtech.monai.feature.reports.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PreviousMonthTotalsDto(
    @SerialName("month") val month: String,
    @SerialName("income_total") val incomeTotal: Long,
    @SerialName("expense_total") val expenseTotal: Long,
)
