package com.djtech.monai.feature.transactions.presentation.common.mapper

import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import java.time.YearMonth

/** The month and filters a list shows, and the filter sheet open over it. */
data class FilterState(
    val month: YearMonth,
    val filter: TransactionFilter,
    val sheet: FilterSheet? = null,
)

/**
 * Applies a filter chip or sheet intent. Sheets keep their choice to themselves until Apply;
 * months after [currentMonth] can't be picked.
 */
fun FilterState.reduce(intent: FilterIntent, currentMonth: YearMonth): FilterState = when (intent) {
    is FilterIntent.Open -> copy(sheet = sheetFor(intent.kind))
    is FilterIntent.Remove -> when (intent.kind) {
        FilterSheetKind.MONTH -> this
        FilterSheetKind.WALLET -> copy(filter = filter.copy(walletId = null))
        FilterSheetKind.CATEGORY -> copy(filter = filter.copy(categoryId = null))
        FilterSheetKind.TYPE -> copy(filter = filter.copy(type = null))
    }

    FilterIntent.RemoveAll -> copy(filter = TransactionFilter())
    is FilterIntent.PickMonth -> updateSheet<FilterSheet.Month> {
        if (intent.month > currentMonth) it else it.copy(selected = intent.month)
    }

    is FilterIntent.ShowYear -> updateSheet<FilterSheet.Month> {
        it.copy(year = intent.year.coerceAtMost(currentMonth.year))
    }

    is FilterIntent.PickWallet -> updateSheet<FilterSheet.Wallet> { it.copy(selectedId = intent.walletId) }
    is FilterIntent.PickCategory -> updateSheet<FilterSheet.Category> { it.copy(selectedId = intent.categoryId) }
    is FilterIntent.PickType -> updateSheet<FilterSheet.Type> { it.copy(selected = intent.type) }
    FilterIntent.ClearSheet -> copy(
        sheet = when (sheet) {
            is FilterSheet.Wallet -> sheet.copy(selectedId = null)
            is FilterSheet.Category -> sheet.copy(selectedId = null)
            is FilterSheet.Type -> sheet.copy(selected = null)
            is FilterSheet.Month, null -> sheet
        },
    )

    FilterIntent.Apply -> when (val open = sheet) {
        is FilterSheet.Month -> copy(month = open.selected, sheet = null)
        is FilterSheet.Wallet -> copy(filter = filter.copy(walletId = open.selectedId), sheet = null)
        is FilterSheet.Category -> copy(filter = filter.copy(categoryId = open.selectedId), sheet = null)
        is FilterSheet.Type -> copy(filter = filter.copy(type = open.selected), sheet = null)
        null -> this
    }

    FilterIntent.Dismiss -> copy(sheet = null)
}

private fun FilterState.sheetFor(kind: FilterSheetKind): FilterSheet = when (kind) {
    FilterSheetKind.MONTH -> FilterSheet.Month(year = month.year, selected = month)
    FilterSheetKind.WALLET -> FilterSheet.Wallet(filter.walletId)
    FilterSheetKind.CATEGORY -> FilterSheet.Category(filter.categoryId)
    FilterSheetKind.TYPE -> FilterSheet.Type(filter.type)
}

private inline fun <reified T : FilterSheet> FilterState.updateSheet(update: (T) -> FilterSheet): FilterState {
    val open = sheet as? T ?: return this
    return copy(sheet = update(open))
}
