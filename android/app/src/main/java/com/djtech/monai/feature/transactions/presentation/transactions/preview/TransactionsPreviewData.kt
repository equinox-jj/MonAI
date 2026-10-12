package com.djtech.monai.feature.transactions.presentation.transactions.preview

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import com.djtech.monai.feature.transactions.presentation.common.preview.TransactionPreviewData
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsState

internal object TransactionsPreviewData {
    val state = TransactionsState(
        month = TransactionPreviewData.month,
        currentMonth = TransactionPreviewData.month,
        today = TransactionPreviewData.today,
        zone = TransactionPreviewData.zone,
        lookups = TransactionPreviewData.lookups,
        wallets = TransactionPreviewData.wallets,
        categories = TransactionPreviewData.categories.filter { it.type == CategoryType.EXPENSE },
        totals = MonthTotals(income = 8_500_000, expense = 2_415_000),
        dailyNets = TransactionPreviewData.transactions.groupBy { it.date }.mapValues { (_, day) ->
            -day.filter { it.categoryId != null }.sumOf { it.amount }
        },
    )

    /** The sample transactions with a header above each day, as the ViewModel pages them. */
    val items: List<TransactionListItem> = TransactionPreviewData.transactions
        .groupBy { it.date }
        .flatMap { (date, day) -> listOf(TransactionListItem.Day(date)) + day.map(TransactionListItem::Entry) }
}
