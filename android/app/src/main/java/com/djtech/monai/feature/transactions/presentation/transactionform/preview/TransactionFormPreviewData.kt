package com.djtech.monai.feature.transactions.presentation.transactionform.preview

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.preview.TransactionPreviewData
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormState
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormMode

internal object TransactionFormPreviewData {
    val add = TransactionFormState(
        mode = TransactionFormMode.Add,
        today = TransactionPreviewData.today,
        amount = 35_000,
        walletId = "bca",
        categoryId = "food",
        categories = TransactionPreviewData.categories.filter { it.type == CategoryType.EXPENSE },
        wallets = TransactionPreviewData.wallets,
        lookups = TransactionPreviewData.lookups,
    )

    val transfer = add.copy(type = TransactionType.TRANSFER, categoryId = null, toWalletId = "gopay", amount = 500_000)

    val edit = add.copy(
        mode = TransactionFormMode.Edit("t1"),
        amount = 53_000,
        originalAmount = 35_000,
        walletId = "gopay",
        note = "Makan siang",
    )
}
