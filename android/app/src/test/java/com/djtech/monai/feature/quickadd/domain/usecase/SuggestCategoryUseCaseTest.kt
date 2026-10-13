package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.feature.quickadd.domain.model.QuickAddError
import com.djtech.monai.feature.quickadd.domain.repository.FakeQuickAddRepository
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class SuggestCategoryUseCaseTest {

    private val transactions = FakeTransactionRepository()
    private val ai = FakeQuickAddRepository()
    private val suggest = SuggestCategoryUseCase(FindCategoryForNoteUseCase(transactions), ai, testClock())
    private val categories = listOf(
        category("food", name = "Food"),
        category("pets", name = "Pets"),
        category("other", name = "Other", isSystem = true),
    )

    @Test
    fun `the user's earlier choice for the same note comes first`() = runTest {
        transactions.noteCategories = mapOf("kopi kenangan" to "pets")

        assertEquals("pets", suggest("Kopi Kenangan", TransactionType.EXPENSE, categories))
        assertEquals(emptyList<String>(), ai.texts)
    }

    @Test
    fun `then the keyword map`() = runTest {
        assertEquals("food", suggest("ngopi sore", TransactionType.EXPENSE, categories))
        assertEquals(emptyList<String>(), ai.texts)
    }

    @Test
    fun `then the AI, when it is sure`() = runTest {
        ai.result = Outcome.Success(listOf(draft(categoryId = "pets")))

        assertEquals("pets", suggest("royal canin", TransactionType.EXPENSE, categories))
        assertEquals(listOf("royal canin"), ai.texts)
    }

    @Test
    fun `an unsure or failed AI answer suggests nothing`() = runTest {
        ai.result = Outcome.Success(listOf(draft(categoryId = "pets", confidence = draftConfidence(category = 0.4))))
        assertNull(suggest("royal canin", TransactionType.EXPENSE, categories))

        ai.result = Outcome.Failure(QuickAddError.RateLimited)
        assertNull(suggest("royal canin", TransactionType.EXPENSE, categories))
    }

    @Test
    fun `a remembered category that is now hidden is not suggested`() = runTest {
        transactions.noteCategories = mapOf("royal canin" to "hidden")
        ai.result = Outcome.Failure(QuickAddError.Network)

        assertNull(suggest("royal canin", TransactionType.EXPENSE, categories))
    }

    @Test
    fun `short notes and transfers skip the AI`() = runTest {
        assertNull(suggest("ab", TransactionType.EXPENSE, categories))
        assertNull(suggest("royal canin", TransactionType.TRANSFER, categories))
        assertEquals(emptyList<String>(), ai.texts)
    }
}
