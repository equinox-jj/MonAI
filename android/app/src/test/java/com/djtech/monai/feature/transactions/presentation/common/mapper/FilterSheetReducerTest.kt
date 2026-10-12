package com.djtech.monai.feature.transactions.presentation.common.mapper

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.YearMonth

class FilterSheetReducerTest {

    private val start = FilterState(month = OCTOBER, filter = TransactionFilter(walletId = "bca"))

    private fun FilterState.then(vararg intents: FilterIntent) =
        intents.fold(this) { state, intent -> state.reduce(intent, currentMonth = OCTOBER) }

    @Test
    fun `a sheet opens on the current choice and only applies on Apply`() {
        val picked = start.then(FilterIntent.Open(FilterSheetKind.WALLET), FilterIntent.PickWallet("gopay"))

        assertEquals(FilterSheet.Wallet("gopay"), picked.sheet)
        assertEquals("bca", picked.filter.walletId)
        assertEquals(TransactionFilter(walletId = "gopay"), picked.then(FilterIntent.Apply).filter)
        assertEquals(null, picked.then(FilterIntent.Apply).sheet)
    }

    @Test
    fun `dismissing a sheet keeps the old filter`() {
        val dismissed = start.then(
            FilterIntent.Open(FilterSheetKind.CATEGORY),
            FilterIntent.PickCategory("food"),
            FilterIntent.Dismiss,
        )

        assertEquals(start, dismissed)
    }

    @Test
    fun `clear in a sheet selects all, and applying it removes the filter`() {
        val cleared = start.then(FilterIntent.Open(FilterSheetKind.WALLET), FilterIntent.ClearSheet)

        assertEquals(FilterSheet.Wallet(null), cleared.sheet)
        assertEquals(TransactionFilter(), cleared.then(FilterIntent.Apply).filter)
    }

    @Test
    fun `type sheet picks one type or all`() {
        val expense = start.then(
            FilterIntent.Open(FilterSheetKind.TYPE),
            FilterIntent.PickType(TransactionType.EXPENSE),
            FilterIntent.Apply,
        )

        assertEquals(TransactionType.EXPENSE, expense.filter.type)
        val all = expense.then(
            FilterIntent.Open(FilterSheetKind.TYPE),
            FilterIntent.PickType(null),
            FilterIntent.Apply,
        )
        assertEquals(null, all.filter.type)
    }

    @Test
    fun `chip removal and all types drop filters at once`() {
        val both = start.copy(filter = TransactionFilter(walletId = "bca", categoryId = "food"))

        val noWallet = both.then(FilterIntent.Remove(FilterSheetKind.WALLET))

        assertEquals(TransactionFilter(categoryId = "food"), noWallet.filter)
        assertEquals(TransactionFilter(), both.then(FilterIntent.RemoveAll).filter)
    }

    @Test
    fun `month picker steps years up to the current one and skips future months`() {
        val sheet = start.then(FilterIntent.Open(FilterSheetKind.MONTH))
        assertEquals(FilterSheet.Month(2026, OCTOBER), sheet.sheet)

        assertEquals(FilterSheet.Month(2026, OCTOBER), sheet.then(FilterIntent.ShowYear(2027)).sheet)
        assertEquals(FilterSheet.Month(2026, OCTOBER), sheet.then(FilterIntent.PickMonth(YearMonth.of(2026, 11))).sheet)

        val march = sheet.then(
            FilterIntent.ShowYear(2025),
            FilterIntent.PickMonth(YearMonth.of(2025, 3)),
            FilterIntent.Apply,
        )
        assertEquals(YearMonth.of(2025, 3), march.month)
        assertEquals(null, march.sheet)
    }

    @Test
    fun `picks for another sheet are ignored`() {
        val sheet = start.then(FilterIntent.Open(FilterSheetKind.TYPE), FilterIntent.PickWallet("gopay"))

        assertEquals(FilterSheet.Type(null), sheet.sheet)
    }
}
