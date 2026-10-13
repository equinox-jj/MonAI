package com.djtech.monai.core.model

import java.time.LocalDate

/**
 * A transaction the AI or the local parser filled in from a phrase or receipt.
 * Every field may be missing; the user completes and confirms it before saving.
 */
data class TransactionDraft(
    val type: TransactionType?,
    /** Rupiah. */
    val amount: Long?,
    val walletId: String?,
    val toWalletId: String?,
    val categoryId: String?,
    val date: LocalDate?,
    val note: String?,
    val merchant: String?,
    val confidence: DraftConfidence,
)

/** Per-field confidence from 0.0 to 1.0; low values are highlighted for review. */
data class DraftConfidence(
    val type: Double,
    val amount: Double,
    val wallet: Double,
    val category: Double,
    val date: Double,
)

/** Below this a drafted field is highlighted for the user to check. */
const val LOW_CONFIDENCE = 0.7

fun Double.isLowConfidence(): Boolean = this < LOW_CONFIDENCE

/** A scanned receipt: the draft for its total plus the line items found. */
data class ReceiptDraft(
    val draft: TransactionDraft,
    val items: List<ReceiptItem>,
)

data class ReceiptItem(
    val name: String,
    val quantity: Double?,
    /** Rupiah. */
    val amount: Long?,
)
