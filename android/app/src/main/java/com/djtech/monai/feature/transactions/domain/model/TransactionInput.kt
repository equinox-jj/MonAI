package com.djtech.monai.feature.transactions.domain.model

import com.djtech.monai.core.model.TransactionType
import java.time.LocalDate

/**
 * What the add and edit forms send. Fields may be unset while the user fills the form; the
 * create and update use cases validate them before anything reaches the repository.
 *
 * @param amount rupiah, positive; [type] gives the direction.
 * @param toWalletId only for a transfer.
 * @param categoryId only for an expense or income.
 */
data class TransactionInput(
    val type: TransactionType,
    val amount: Long,
    val walletId: String?,
    val toWalletId: String?,
    val categoryId: String?,
    val date: LocalDate,
    val note: String?,
    val merchant: String? = null,
)
