package com.djtech.monai.feature.transactions.presentation.search.preview

import com.djtech.monai.feature.transactions.presentation.common.preview.TransactionPreviewData
import com.djtech.monai.feature.transactions.presentation.search.SearchState

internal object SearchPreviewData {
    val state = SearchState(
        month = TransactionPreviewData.month,
        currentMonth = TransactionPreviewData.month,
        today = TransactionPreviewData.today,
        zone = TransactionPreviewData.zone,
        query = "kopi",
        lookups = TransactionPreviewData.lookups,
        wallets = TransactionPreviewData.wallets,
        categories = TransactionPreviewData.categories,
        recentSearches = listOf("parkir", "listrik", "sumber rejeki"),
    )

    val results = TransactionPreviewData.transactions.filter { it.note.orEmpty().contains("Kopi", ignoreCase = true) }
}
