package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class ParseQuickAddUseCaseTest {

    private val transactions = FakeTransactionRepository()
    private val context = ParseContext(
        wallets = listOf(wallet("bca", isDefault = true)),
        categories = listOf(category("food", name = "Food"), category("shopping", name = "Shopping")),
        providers = emptyList(),
        today = LocalDate.of(2026, 10, 10),
    )

    @Test
    fun `the category last used for the same note beats the keyword guess`() = runTest {
        val parse = ParseQuickAddUseCase(
            FindCategoryForNoteUseCase(transactions),
            StandardTestDispatcher(testScheduler),
        )
        transactions.noteCategories = mapOf("kopi" to "shopping")

        val drafts = parse("kopi 25rb sama roti 10rb", context)

        assertEquals(listOf("shopping", "food"), drafts.map { it.categoryId })
        assertEquals(0.9, drafts.first().confidence.category, 0.0)
    }
}
