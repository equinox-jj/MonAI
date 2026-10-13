package com.djtech.monai.feature.wallets.presentation.walletdetail.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.OutflowDay
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.RowFlow
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletRowLookups
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate
import java.time.YearMonth

class WalletDetailStateMappingTest {

    private val lookups = WalletRowLookups(
        categories = mapOf("food" to category("food", name = "Food", icon = "restaurant", color = "#F97316")),
        walletNames = mapOf("bca" to "BCA", "gopay" to "GoPay"),
    )

    @Test
    fun `outflow days run from the 1st to today in the current month, zero when nothing went out`() {
        val days = mapOf(LocalDate.of(2026, 10, 2) to 35_000L).toOutflowDays(OCTOBER, today = LocalDate.of(2026, 10, 3))

        assertEquals(
            listOf(
                OutflowDay(LocalDate.of(2026, 10, 1), 0),
                OutflowDay(LocalDate.of(2026, 10, 2), 35_000),
                OutflowDay(LocalDate.of(2026, 10, 3), 0),
            ),
            days,
        )
    }

    @Test
    fun `a past month shows every day`() {
        val days = emptyMap<LocalDate, Long>().toOutflowDays(YearMonth.of(2026, 9), LocalDate.of(2026, 10, 3))

        assertEquals(30, days.size)
    }

    @Test
    fun `an expense is money out, titled by its note and labelled by its category`() {
        val row = transaction("lunch", note = "Makan siang", walletId = "bca").toWalletRow("bca", lookups)

        assertEquals(RowFlow.OUT, row.flow)
        assertEquals(UiText.Dynamic("Makan siang"), row.title)
        assertEquals(UiText.Dynamic("Food"), row.label)
        assertEquals("restaurant", row.icon)
        assertEquals("#F97316", row.color)
    }

    @Test
    fun `without a note the merchant, then the category, names the row`() {
        assertEquals(
            UiText.Dynamic("Warteg"),
            transaction("a", merchant = "Warteg", walletId = "bca").toWalletRow("bca", lookups).title,
        )
        assertEquals(UiText.Dynamic("Food"), transaction("b", walletId = "bca").toWalletRow("bca", lookups).title)
    }

    @Test
    fun `income is money in`() {
        val row = transaction("salary", type = TransactionType.INCOME, categoryId = null, walletId = "bca")
            .toWalletRow("bca", lookups)

        assertEquals(RowFlow.IN, row.flow)
        assertEquals(UiText.Resource(R.string.wallet_detail_untitled), row.title)
    }

    @Test
    fun `a transfer reads from this wallet's side`() {
        val topUp = transaction(
            "top-up",
            type = TransactionType.TRANSFER,
            walletId = "bca",
            toWalletId = "gopay",
            categoryId = null,
        )

        val out = topUp.toWalletRow("bca", lookups)
        val into = topUp.toWalletRow("gopay", lookups)

        assertEquals(RowFlow.OUT, out.flow)
        assertEquals(UiText.Resource(R.string.wallet_detail_transfer_to, "GoPay"), out.label)
        assertEquals(UiText.Resource(R.string.wallet_detail_transfer), out.title)
        assertEquals(RowFlow.IN, into.flow)
        assertEquals(UiText.Resource(R.string.wallet_detail_transfer_from, "BCA"), into.label)
    }

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)
    }
}
