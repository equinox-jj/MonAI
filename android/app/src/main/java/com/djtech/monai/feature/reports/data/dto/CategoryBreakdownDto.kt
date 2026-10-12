package com.djtech.monai.feature.reports.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CategoryBreakdownDto(
    @SerialName("category_id") val categoryId: String,
    @SerialName("name") val name: String,
    @SerialName("icon") val icon: String? = null,
    @SerialName("color") val color: String? = null,
    @SerialName("amount") val amount: Long,
    @SerialName("share_percent") val sharePercent: Double,
    @SerialName("previous_amount") val previousAmount: Long,
    @SerialName("change_percent") val changePercent: Double? = null,
)
