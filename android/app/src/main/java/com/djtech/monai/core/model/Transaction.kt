package com.djtech.monai.core.model

import java.time.Instant
import java.time.LocalDate

enum class TransactionType { EXPENSE, INCOME, TRANSFER }

/** How a transaction was entered. */
enum class TransactionSource { MANUAL, QUICK_ADD, RECEIPT }

/**
 * A transfer has [toWalletId] and no [categoryId]; an expense or income has
 * [categoryId] and no [toWalletId].
 */
data class Transaction(
    val id: String,
    val type: TransactionType,
    /** Rupiah, always positive; [type] gives the direction. */
    val amount: Long,
    /** The source wallet. */
    val walletId: String,
    val toWalletId: String?,
    val categoryId: String?,
    /** Business date in the user's timezone. */
    val date: LocalDate,
    val note: String?,
    val merchant: String?,
    /** Presigned GET URL; expires after 15 minutes. */
    val receiptUrl: String?,
    val source: TransactionSource,
    val createdAt: Instant,
    val updatedAt: Instant,
)
