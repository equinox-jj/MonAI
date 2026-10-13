package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.isLowConfidence
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.core.model.wallet
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDate

class QuickAddParserTest {

    private val today = LocalDate.of(2026, 10, 10)
    private val gopay = paymentProvider("gopay", name = "GoPay").copy(aliases = listOf("gopay", "gpay"))
    private val context = ParseContext(
        wallets = listOf(
            wallet("w-bca", name = "BCA Tabungan", isDefault = true),
            wallet("w-gopay", name = "GoPay", providerId = gopay.id, type = WalletType.E_WALLET),
            wallet("w-mandiri", name = "Mandiri"),
        ),
        categories = listOf(
            category("food", name = "Food"),
            category("transport", name = "Transport"),
            category("other", name = "Other", isSystem = true),
            category("salary", name = "Salary", type = CategoryType.INCOME),
            category("other-income", name = "Other Income", type = CategoryType.INCOME, isSystem = true),
        ),
        providers = listOf(gopay),
        today = today,
    )

    private fun parse(text: String) = QuickAddParser.parse(text, context)

    @Test
    fun `makan siang with gopay is a confident food expense today`() {
        val draft = parse("makan siang 35rb pakai gopay").single()

        assertEquals(TransactionType.EXPENSE, draft.type)
        assertEquals(35_000L, draft.amount)
        assertEquals("food", draft.categoryId)
        assertEquals("w-gopay", draft.walletId)
        assertEquals(today, draft.date)
        assertEquals("Makan siang", draft.note)
        with(draft.confidence) {
            assertFalse(amount.isLowConfidence())
            assertFalse(category.isLowConfidence())
            assertFalse(wallet.isLowConfidence())
        }
    }

    @Test
    fun `two amounts make two drafts that share the date and the default wallet`() {
        val drafts = parse("kopi 25rb sama parkir 5rb kmrn")

        assertEquals(listOf(25_000L, 5_000L), drafts.map { it.amount })
        assertEquals(listOf("food", "transport"), drafts.map { it.categoryId })
        assertEquals(listOf("Kopi", "Parkir"), drafts.map { it.note })
        assertTrue(drafts.all { it.date == today.minusDays(1) })
        assertTrue(drafts.all { it.walletId == "w-bca" && it.confidence.wallet.isLowConfidence() })
    }

    @Test
    fun `without an amount the draft has none and falls back to Other`() {
        val draft = parse("bayar arisan ke tante via mandiri").single()

        assertNull(draft.amount)
        assertEquals(0.0, draft.confidence.amount, 0.0)
        assertEquals("other", draft.categoryId)
        assertTrue(draft.confidence.category.isLowConfidence())
        assertEquals("w-mandiri", draft.walletId)
        assertEquals("Bayar arisan ke tante", draft.note)
    }

    @Test
    fun `gajian is income`() {
        val draft = parse("gajian 8jt ke bca tabungan").single()

        assertEquals(TransactionType.INCOME, draft.type)
        assertEquals(8_000_000L, draft.amount)
        assertEquals("salary", draft.categoryId)
        assertEquals("w-bca", draft.walletId)
    }

    @Test
    fun `topup moves money from the source into the named wallet`() {
        val draft = parse("topup gopay 100rb dari mandiri").single()

        assertEquals(TransactionType.TRANSFER, draft.type)
        assertEquals("w-mandiri", draft.walletId)
        assertEquals("w-gopay", draft.toWalletId)
        assertNull(draft.categoryId)
    }

    @Test
    fun `a topup without a source uses the default wallet`() {
        val draft = parse("topup gopay 50rb").single()

        assertEquals("w-bca", draft.walletId)
        assertEquals("w-gopay", draft.toWalletId)
    }

    @Test
    fun `a day number is a date, not an amount`() {
        val draft = parse("listrik 300rb tgl 5").single()

        assertEquals(300_000L, draft.amount)
        assertEquals(LocalDate.of(2026, 10, 5), draft.date)
    }

    @Test
    fun `blank text has no drafts`() {
        assertEquals(emptyList<Any>(), parse("   "))
    }
}
