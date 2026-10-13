package com.djtech.monai.feature.budgets.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `PUT /budgets/{month}`; [limitAmount] is rupiah. */
@Serializable
data class SetBudgetRequestDto(
    @SerialName("limit_amount") val limitAmount: Long,
)
