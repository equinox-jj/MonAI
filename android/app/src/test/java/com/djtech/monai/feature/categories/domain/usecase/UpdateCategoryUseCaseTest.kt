package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class UpdateCategoryUseCaseTest {

    private val kopi = category(
        "kopi",
        name = "Kopi",
        icon = "local_cafe",
        color = "#6366F1",
        isDefault = false,
    )
    private val repository = FakeCategoryRepository(listOf(kopi))
    private val updateCategory = UpdateCategoryUseCase(repository)

    @Test
    fun `sends only the trimmed fields that changed`() = runTest {
        val result = updateCategory(kopi, input(name = "  Coffee ", color = "#6366F1"))

        assertEquals("Coffee", (result as Outcome.Success).data.name)
        assertEquals(listOf("kopi" to CategoryChanges(name = "Coffee")), repository.updates)
    }

    @Test
    fun `nothing changed sends nothing`() = runTest {
        assertEquals(Outcome.Success(kopi), updateCategory(kopi, input()))
        assertTrue(repository.updates.isEmpty())
    }

    @Test
    fun `a blank name fails without a request`() = runTest {
        assertEquals(
            Outcome.Failure(CategoryError.InvalidName(CategoryNameIssue.REQUIRED)),
            updateCategory(kopi, input(name = " ")),
        )
        assertTrue(repository.updates.isEmpty())
    }

    private fun input(name: String = "Kopi", color: String = "#6366F1") = CategoryInput(
        name = name,
        type = CategoryType.EXPENSE,
        icon = "local_cafe",
        color = color,
    )
}
