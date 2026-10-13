package com.djtech.monai.core.network.model

import com.djtech.monai.core.model.DraftConfidence
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.time.LocalDate

/** The API's `TransactionDraft`, returned by `/ai/parse-transaction`. Fields the server couldn't validate are null. */
@Serializable
data class TransactionDraftDto(
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
)

/** 0.0 to 1.0 per field; a missing value counts as unsure. */
@Serializable
data class DraftConfidenceDto(
    @SerialName("type") val type: Double = 0.0,
    @SerialName("amount") val amount: Double = 0.0,
    @SerialName("wallet") val wallet: Double = 0.0,
    @SerialName("category") val category: Double = 0.0,
    @SerialName("date") val date: Double = 0.0,
)

fun TransactionDraftDto.asModel(): TransactionDraft = TransactionDraft(
    type = type,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date?.let(LocalDate::parse),
    note = note,
    merchant = merchant,
    confidence = confidence.asModel(),
)

fun DraftConfidenceDto.asModel(): DraftConfidence = DraftConfidence(
    type = type,
    amount = amount,
    wallet = wallet,
    category = category,
    date = date,
)
