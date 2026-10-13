package com.djtech.monai.feature.receipt.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ReceiptItemDto(
    @SerialName("name") val name: String,
    @SerialName("quantity") val quantity: Double? = null,
    @SerialName("amount") val amount: Long? = null,
)
