package com.djtech.monai.feature.transactions.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** A PATCH that only links an uploaded receipt photo; every other field keeps its value. */
@Serializable
data class AttachReceiptRequestDto(
    @SerialName("receipt_key") val receiptKey: String,
)
