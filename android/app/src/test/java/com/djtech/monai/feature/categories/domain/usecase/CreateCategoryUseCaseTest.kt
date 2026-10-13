package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.event.CategoryCreationEvents
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class CreateCategoryUseCaseTest {

    private val repository = FakeCategoryRepository()
    private val creationEvents = CategoryCreationEvents()
    private val createCategory = CreateCategoryUseCase(repository, creationEvents)

    private val kopi = CategoryInput(
        name = "Kopi",
        type = CategoryType.EXPENSE,
        icon = "local_cafe",
        color = "#6366F1",
    )

    @Test
    fun `creates the category with a trimmed name and returns it`() = runTest {
        val result = createCategory(kopi.copy(name = "  Kopi "))

        assertEquals(listOf(kopi), repository.createdInputs)
        assertEquals("Kopi", (result as Outcome.Success).data.name)
    }

    @Test
    fun `returns the repository's failure`() = runTest {
        repository.createError = CategoryError.Network

        assertEquals(Outcome.Failure(CategoryError.Network), createCategory(kopi))
    }

    @Test
    fun `a blank name fails without a request`() = runTest {
        assertEquals(
            Outcome.Failure(CategoryError.InvalidName(CategoryNameIssue.REQUIRED)),
            createCategory(kopi.copy(name = "   ")),
        )
        assertTrue(repository.createdInputs.isEmpty())
    }

    @Test
    fun `a name over 30 characters fails without a request`() = runTest {
        assertEquals(
            Outcome.Failure(CategoryError.InvalidName(CategoryNameIssue.TOO_LONG)),
            createCategory(kopi.copy(name = "a".repeat(31))),
        )
        assertTrue(repository.createdInputs.isEmpty())
    }

    @Test
    fun `a 30 character name is fine`() = runTest {
        assertTrue(createCategory(kopi.copy(name = "a".repeat(30))) is Outcome.Success)
    }

    @Test
    fun `announces the created category`() = runTest {
        val created = collectCreations()

        val result = createCategory(kopi)

        assertEquals(listOf((result as Outcome.Success).data), created)
    }

    @Test
    fun `a failed create announces nothing`() = runTest {
        val created = collectCreations()
        repository.createError = CategoryError.Network

        createCategory(kopi)

        assertEquals(emptyList<Category>(), created)
    }

    private fun TestScope.collectCreations(): List<Category> {
        val created = mutableListOf<Category>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { creationEvents.created.toList(created) }
        return created
    }
}
