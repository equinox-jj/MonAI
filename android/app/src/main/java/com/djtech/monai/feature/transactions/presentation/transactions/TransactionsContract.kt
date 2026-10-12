package com.djtech.monai.feature.transactions.presentation.transactions

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.LocalDate
import java.time.YearMonth
import java.time.ZoneId

/**
 * The list itself is paged and comes from [TransactionsViewModel.transactions]; this is everything
 * around it.
 *
 * @param currentMonth the month of [today]: later months can't be shown.
 * @param wallets every wallet, archived ones included, for the wallet filter.
 * @param categories categories that are not hidden, for the category filter.
 * @param totals [month]'s income and expense from its report; null until it is cached.
 * @param dailyNets each cached day's income minus expenses, for the day headers.
 * @param monthPickerTotals spent per month of the year the month picker shows, where cached.
 * @param selectedId the transaction in the detail pane on a wide screen.
 */
@Immutable
data class TransactionsState(
    val month: YearMonth,
    val currentMonth: YearMonth,
    val today: LocalDate,
    val zone: ZoneId,
    val filter: TransactionFilter = TransactionFilter(),
    val sheet: FilterSheet? = null,
    val lookups: TransactionLookups = TransactionLookups(),
    val wallets: List<Wallet> = emptyList(),
    val categories: List<Category> = emptyList(),
    val totals: MonthTotals? = null,
    val dailyNets: Map<LocalDate, Long> = emptyMap(),
    val monthPickerTotals: Map<YearMonth, Long> = emptyMap(),
    val selectedId: String? = null,
) {
    val canShowNextMonth: Boolean get() = month < currentMonth
}

sealed interface TransactionsIntent {
    data class Filter(val intent: FilterIntent) : TransactionsIntent

    data object PreviousMonth : TransactionsIntent

    data object NextMonth : TransactionsIntent

    /** Pull-to-refresh and retry: the totals and names. The screen refreshes the paged list itself. */
    data object Refresh : TransactionsIntent

    /** On a wide screen, shows [id] in the detail pane instead of opening it. */
    data class Select(val id: String) : TransactionsIntent

    /** Swipe to delete; the shell offers undo. */
    data class Delete(val id: String) : TransactionsIntent

    data class Open(val destination: TransactionsDestination) : TransactionsIntent
}

sealed interface TransactionsEffect {
    data class Navigate(val destination: TransactionsDestination) : TransactionsEffect

    data class ShowMessage(val message: UiText, val isOffline: Boolean = false) : TransactionsEffect
}

sealed interface TransactionsDestination {
    /** Search, starting in the [month] the list shows. */
    data class Search(val month: YearMonth) : TransactionsDestination

    data object Add : TransactionsDestination

    data class Detail(val id: String) : TransactionsDestination

    data class Edit(val id: String) : TransactionsDestination
}
