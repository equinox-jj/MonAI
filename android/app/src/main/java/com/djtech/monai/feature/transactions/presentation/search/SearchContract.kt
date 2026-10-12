package com.djtech.monai.feature.transactions.presentation.search

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.LocalDate
import java.time.YearMonth
import java.time.ZoneId

/**
 * The results are paged and come from [SearchViewModel.results]; this is everything around them.
 *
 * @param month the month searched on the server; [allMonths] searches every cached month instead.
 * @param recentSearches the last searches, newest first, offered while [query] is blank.
 */
@Immutable
data class SearchState(
    val month: YearMonth,
    val currentMonth: YearMonth,
    val today: LocalDate,
    val zone: ZoneId,
    val query: String = "",
    val allMonths: Boolean = false,
    val filter: TransactionFilter = TransactionFilter(),
    val sheet: FilterSheet? = null,
    val lookups: TransactionLookups = TransactionLookups(),
    val wallets: List<Wallet> = emptyList(),
    val categories: List<Category> = emptyList(),
    val monthPickerTotals: Map<YearMonth, Long> = emptyMap(),
    val recentSearches: List<String> = emptyList(),
) {
    val hasQuery: Boolean get() = query.isNotBlank()
}

sealed interface SearchIntent {
    data class QueryChanged(val query: String) : SearchIntent

    /** The keyboard's search key: keeps the text in recent searches. */
    data object Submit : SearchIntent

    data object ClearQuery : SearchIntent

    data class UseRecent(val query: String) : SearchIntent

    /** Searches every cached month on the device, offline too. */
    data object SearchAllMonths : SearchIntent

    data object SearchMonthOnly : SearchIntent

    data class Filter(val intent: FilterIntent) : SearchIntent

    data class OpenResult(val id: String) : SearchIntent

    data object Back : SearchIntent
}

sealed interface SearchEffect {
    data class OpenTransaction(val id: String) : SearchEffect

    data object NavigateBack : SearchEffect
}
