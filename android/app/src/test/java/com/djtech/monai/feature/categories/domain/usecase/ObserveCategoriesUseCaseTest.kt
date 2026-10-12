package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveCategoriesUseCaseTest {

    @Test
    fun `emits every cached category`() = runTest {
        val categories = listOf(category("food"), category("bills"))
        val observeCategories = ObserveCategoriesUseCase(FakeCategoryRepository(categories))

        assertEquals(categories, observeCategories().first())
    }
}
