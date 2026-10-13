package com.djtech.monai.feature.transactions.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `POST /transactions/receipt`: the key to send with a create or update within 24 hours. */
@Serializable
data class ReceiptUploadDto(
    @SerialName("receipt_key") val receiptKey: String,
)
