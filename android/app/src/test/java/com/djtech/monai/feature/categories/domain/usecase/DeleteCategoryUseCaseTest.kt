package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class DeleteCategoryUseCaseTest {

    private val repository = FakeCategoryRepository(listOf(category("kopi"), category("other")))
    private val deleteCategory = DeleteCategoryUseCase(repository)

    @Test
    fun `deletes an unused category without a target`() = runTest {
        assertEquals(Outcome.Success(Unit), deleteCategory("kopi"))
        assertEquals(listOf("kopi" to null), repository.deletions)
    }

    @Test
    fun `a category in use needs a target, then moves its transactions there`() = runTest {
        repository.categoriesInUse += "kopi"

        assertEquals(Outcome.Failure(CategoryError.HasTransactions), deleteCategory("kopi"))
        assertEquals(Outcome.Success(Unit), deleteCategory("kopi", moveTo = "other"))
        assertEquals(listOf("other"), repository.categories.value.map { it.id })
    }
}
