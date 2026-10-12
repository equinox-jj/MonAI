package com.djtech.monai.feature.transactions.data.dto

import com.djtech.monai.core.model.TransactionType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * The whole edited form, sent as a PATCH. Encode it with explicit nulls (see the mapper):
 * a null here clears the field on the server. `receipt_key` is left out so the receipt stays.
 */
@Serializable
data class UpdateTransactionRequestDto(
    @SerialName("type") val type: TransactionType,
    @SerialName("amount") val amount: Long,
    @SerialName("wallet_id") val walletId: String,
    @SerialName("to_wallet_id") val toWalletId: String?,
    @SerialName("category_id") val categoryId: String?,
    /** `YYYY-MM-DD`. */
    @SerialName("date") val date: String,
    @SerialName("note") val note: String?,
    @SerialName("merchant") val merchant: String?,
)
