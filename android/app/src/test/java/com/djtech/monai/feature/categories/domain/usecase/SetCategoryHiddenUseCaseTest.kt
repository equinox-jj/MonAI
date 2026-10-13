package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SetCategoryHiddenUseCaseTest {

    private val repository = FakeCategoryRepository(listOf(category("food")))
    private val setHidden = SetCategoryHiddenUseCase(repository)

    @Test
    fun `hides and shows a category`() = runTest {
        assertEquals(Outcome.Success(Unit), setHidden("food", hidden = true))
        assertTrue(repository.categories.value.single().isHidden)

        setHidden("food", hidden = false)
        assertEquals(false, repository.categories.value.single().isHidden)
    }

    @Test
    fun `passes on a locked category`() = runTest {
        repository.updateError = CategoryError.Locked

        assertEquals(Outcome.Failure(CategoryError.Locked), setHidden("food", hidden = true))
    }
}
