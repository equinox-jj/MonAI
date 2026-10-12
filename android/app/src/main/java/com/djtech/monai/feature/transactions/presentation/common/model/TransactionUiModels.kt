package com.djtech.monai.feature.transactions.presentation.common.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import java.time.LocalDate
import java.time.YearMonth

/**
 * Names for the ids a transaction carries. Archived wallets and hidden categories are included,
 * so old transactions still show their names.
 */
@Immutable
data class TransactionLookups(
    val categories: Map<String, Category> = emptyMap(),
    val wallets: Map<String, Wallet> = emptyMap(),
) {
    fun category(id: String?): Category? = id?.let(categories::get)

    fun wallet(id: String?): Wallet? = id?.let(wallets::get)

    companion object {
        fun of(categories: List<Category>, wallets: List<Wallet>) = TransactionLookups(
            categories = categories.associateBy(Category::id),
            wallets = wallets.associateBy(Wallet::id),
        )
    }
}

/** A paged list row: a day header above its transactions, or a transaction. */
@Immutable
sealed interface TransactionListItem {
    val key: String

    data class Day(val date: LocalDate) : TransactionListItem {
        override val key: String get() = "day-$date"
    }

    data class Entry(val transaction: Transaction) : TransactionListItem {
        override val key: String get() = transaction.id
    }
}

/** The month's totals from its report. Amounts are rupiah. */
@Immutable
data class MonthTotals(val income: Long, val expense: Long)

enum class FilterSheetKind { MONTH, WALLET, CATEGORY, TYPE }

/** An open filter sheet and the choice made in it, not applied until Apply. */
@Immutable
sealed interface FilterSheet {
    data class Month(val year: Int, val selected: YearMonth) : FilterSheet

    data class Wallet(val selectedId: String?) : FilterSheet

    data class Category(val selectedId: String?) : FilterSheet

    data class Type(val selected: TransactionType?) : FilterSheet
}

/** What the filter chips and sheets send; the list and search screens wrap these in their own intents. */
sealed interface FilterIntent {
    data class Open(val kind: FilterSheetKind) : FilterIntent

    /** The chip's clear button: drops that filter at once. */
    data class Remove(val kind: FilterSheetKind) : FilterIntent

    data class PickMonth(val month: YearMonth) : FilterIntent

    data class ShowYear(val year: Int) : FilterIntent

    data class PickWallet(val walletId: String?) : FilterIntent

    data class PickCategory(val categoryId: String?) : FilterIntent

    data class PickType(val type: TransactionType?) : FilterIntent

    /** The "All types" chip: drops every filter at once. */
    data object RemoveAll : FilterIntent

    /** Clear or Reset inside the open sheet: back to "all", still not applied. */
    data object ClearSheet : FilterIntent

    data object Apply : FilterIntent

    data object Dismiss : FilterIntent
}
