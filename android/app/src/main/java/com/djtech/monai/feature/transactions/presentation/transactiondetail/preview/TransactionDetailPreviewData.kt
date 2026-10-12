package com.djtech.monai.feature.transactions.presentation.transactiondetail.preview

import com.djtech.monai.feature.transactions.presentation.common.preview.TransactionPreviewData
import com.djtech.monai.feature.transactions.presentation.transactiondetail.TransactionDetailState

internal object TransactionDetailPreviewData {
    /** "Belanja bulanan": an expense with a merchant and a scanned receipt. */
    val shopping = TransactionDetailState(
        today = TransactionPreviewData.today,
        transaction = TransactionPreviewData.transactions.first { it.id == "t4" },
        lookups = TransactionPreviewData.lookups,
        isLoading = false,
    )

    val transfer = shopping.copy(transaction = TransactionPreviewData.transactions.first { it.id == "t5" })
}
