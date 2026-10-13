package com.djtech.monai.navigation

import com.djtech.monai.core.model.DraftConfidence
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import kotlinx.serialization.Serializable
import java.time.LocalDate

// Drafts travel in route keys, so a draft being reviewed survives process death.

/** A [TransactionDraft] in a route; [date] is `YYYY-MM-DD`. */
@Serializable
data class DraftKey(
    val type: TransactionType?,
    val amount: Long?,
    val walletId: String?,
    val toWalletId: String?,
    val categoryId: String?,
    val date: String?,
    val note: String?,
    val merchant: String?,
    val confidence: DraftConfidenceKey,
)

@Serializable
data class DraftConfidenceKey(
    val type: Double,
    val amount: Double,
    val wallet: Double,
    val category: Double,
    val date: Double,
)

@Serializable
data class ReceiptDraftKey(val draft: DraftKey, val items: List<ReceiptItemKey>)

@Serializable
data class ReceiptItemKey(val name: String, val quantity: Double?, val amount: Long?)

fun TransactionDraft.toKey() = DraftKey(
    type = type,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date?.toString(),
    note = note,
    merchant = merchant,
    confidence = DraftConfidenceKey(
        type = confidence.type,
        amount = confidence.amount,
        wallet = confidence.wallet,
        category = confidence.category,
        date = confidence.date,
    ),
)

fun DraftKey.toModel() = TransactionDraft(
    type = type,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date?.let(LocalDate::parse),
    note = note,
    merchant = merchant,
    confidence = DraftConfidence(
        type = confidence.type,
        amount = confidence.amount,
        wallet = confidence.wallet,
        category = confidence.category,
        date = confidence.date,
    ),
)

fun ReceiptDraft.toKey() = ReceiptDraftKey(
    draft = draft.toKey(),
    items = items.map { ReceiptItemKey(it.name, it.quantity, it.amount) },
)

fun ReceiptDraftKey.toModel() = ReceiptDraft(
    draft = draft.toModel(),
    items = items.map { ReceiptItem(it.name, it.quantity, it.amount) },
)
