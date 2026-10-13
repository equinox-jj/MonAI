package com.djtech.monai.feature.receipt.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `data` of `POST /ai/parse-receipt`. */
@Serializable
data class ParsedReceiptDto(
    @SerialName("draft") val draft: ReceiptDraftDto,
)
