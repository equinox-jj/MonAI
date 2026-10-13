package com.djtech.monai.feature.receipt.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ParseReceiptRequestDto(
    @SerialName("ocr_text") val ocrText: String,
    /** The user's local date, `YYYY-MM-DD`. */
    @SerialName("today") val today: String,
    @SerialName("timezone") val timezone: String,
)
