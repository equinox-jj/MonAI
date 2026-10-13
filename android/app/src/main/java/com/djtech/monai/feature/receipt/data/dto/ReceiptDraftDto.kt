package com.djtech.monai.feature.receipt.data.dto

import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.network.model.DraftConfidenceDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The API's `ReceiptDraft`: every `TransactionDraft` field, flattened, plus the line items. */
@Serializable
data class ReceiptDraftDto(
    @SerialName("type") val type: TransactionType? = null,
    @SerialName("amount") val amount: Long? = null,
    @SerialName("wallet_id") val walletId: String? = null,
    @SerialName("to_wallet_id") val toWalletId: String? = null,
    @SerialName("category_id") val categoryId: String? = null,
    /** `YYYY-MM-DD`. */
    @SerialName("date") val date: String? = null,
    @SerialName("note") val note: String? = null,
    @SerialName("merchant") val merchant: String? = null,
    @SerialName("confidence") val confidence: DraftConfidenceDto = DraftConfidenceDto(),
    @SerialName("items") val items: List<ReceiptItemDto> = emptyList(),
)
