package com.djtech.monai.feature.transactions.domain.model

import com.djtech.monai.core.model.TransactionType

/**
 * Narrows a transaction list. The API takes one of each, so every filter is single-choice;
 * null means "all". [walletId] matches the source or the destination wallet.
 */
data class TransactionFilter(
    val walletId: String? = null,
    val categoryId: String? = null,
    val type: TransactionType? = null,
) {
    val isEmpty: Boolean get() = walletId == null && categoryId == null && type == null
}
