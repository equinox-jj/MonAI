package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshCategoriesUseCaseTest {

    private val repository = FakeCategoryRepository()
    private val refreshCategories = RefreshCategoriesUseCase(repository)

    @Test
    fun `refreshes through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(CategoryError.Network)

        assertEquals(Outcome.Failure(CategoryError.Network), refreshCategories())
        assertEquals(1, repository.refreshCount)
    }
}
