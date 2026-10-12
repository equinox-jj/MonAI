package com.djtech.monai.feature.budgets.data.dto

import com.djtech.monai.core.model.BudgetStatus
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** [month] is `YYYY-MM`. */
@Serializable
data class BudgetDto(
    @SerialName("month") val month: String,
    @SerialName("limit_amount") val limitAmount: Long,
    @SerialName("spent") val spent: Long,
    @SerialName("remaining") val remaining: Long,
    @SerialName("progress_percent") val progressPercent: Double,
    @SerialName("status") val status: BudgetStatus,
)
