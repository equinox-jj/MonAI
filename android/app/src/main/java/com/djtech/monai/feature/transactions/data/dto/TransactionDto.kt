package com.djtech.monai.feature.transactions.data.dto

import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TransactionDto(
    @SerialName("id") val id: String,
    @SerialName("type") val type: TransactionType,
    @SerialName("amount") val amount: Long,
    @SerialName("wallet_id") val walletId: String,
    @SerialName("to_wallet_id") val toWalletId: String? = null,
    @SerialName("category_id") val categoryId: String? = null,
    @SerialName("date") val date: String,
    @SerialName("note") val note: String? = null,
    @SerialName("merchant") val merchant: String? = null,
    @SerialName("receipt_url") val receiptUrl: String? = null,
    @SerialName("source") val source: TransactionSource,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
)
