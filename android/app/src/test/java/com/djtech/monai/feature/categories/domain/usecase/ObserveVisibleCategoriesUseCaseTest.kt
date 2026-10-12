package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveVisibleCategoriesUseCaseTest {

    @Test
    fun `emits the type's categories that are not hidden`() = runTest {
        val repository = FakeCategoryRepository(
            listOf(
                category("food"),
                category("old", isHidden = true),
                category("salary", type = CategoryType.INCOME),
            ),
        )

        val visible = ObserveVisibleCategoriesUseCase(repository)(CategoryType.EXPENSE).first()

        assertEquals(listOf(category("food")), visible)
    }
}
