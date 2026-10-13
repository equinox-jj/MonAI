package com.djtech.monai.feature.categories.presentation.categories

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.DeleteCategoryUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.SetCategoryHiddenUseCase
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryKind
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class CategoriesViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val categories = FakeCategoryRepository(
        listOf(
            category("other", name = "Other", isSystem = true),
            category("transport", name = "Transport"),
            category("kopi", name = "Kopi", isDefault = false),
            category("food", name = "Food"),
            category("salary", name = "Salary", type = CategoryType.INCOME),
        ),
    )

    private fun runCategoriesTest(
        block: suspend TestScope.(CategoriesViewModel, MutableList<CategoriesEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = CategoriesViewModel(
            ObserveCategoriesUseCase(categories),
            RefreshCategoriesUseCase(categories),
            SetCategoryHiddenUseCase(categories),
            DeleteCategoryUseCase(categories),
        )
        val effects = mutableListOf<CategoriesEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: CategoriesViewModel, vararg intents: CategoriesIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `lists the type's categories by name with other last, and refreshes`() = runCategoriesTest { vm, _ ->
        val rows = vm.state.value.rows

        assertEquals(listOf("food", "kopi", "transport", "other"), rows.map { it.id })
        assertEquals(
            listOf(CategoryKind.DEFAULT, CategoryKind.CUSTOM, CategoryKind.DEFAULT, CategoryKind.SYSTEM),
            rows.map { it.kind },
        )
        assertFalse(vm.state.value.isLoading)
        assertEquals(1, categories.refreshCount)

        send(vm, CategoriesIntent.SelectType(CategoryType.INCOME))
        assertEquals(listOf("salary"), vm.state.value.rows.map { it.id })
    }

    @Test
    fun `nothing cached and a failed refresh shows the error`() = runTest(mainDispatcherRule.dispatcher) {
        categories.categories.value = emptyList()
        categories.refreshResult = Outcome.Failure(CategoryError.Network)

        runCategoriesTest { vm, _ ->
            assertEquals(UiText.Resource(R.string.categories_error_network), vm.state.value.loadError)

            categories.refreshResult = Outcome.Success(Unit)
            categories.categories.value = listOf(category("food"))
            send(vm, CategoriesIntent.Retry)
            assertNull(vm.state.value.loadError)
        }
    }

    @Test
    fun `hiding and showing goes through the server`() = runCategoriesTest { vm, _ ->
        send(vm, CategoriesIntent.SetHidden("food", hidden = true))

        assertEquals(listOf("food" to CategoryChanges(isHidden = true)), categories.updates)
        assertTrue(vm.state.value.rows.first { it.id == "food" }.isHidden)
    }

    @Test
    fun `an unused custom category is deleted after a confirmation`() = runCategoriesTest { vm, effects ->
        send(vm, CategoriesIntent.Delete("kopi"))
        assertEquals("kopi", vm.state.value.deletion?.category?.id)
        assertFalse(vm.state.value.deletion?.needsTarget ?: true)

        send(vm, CategoriesIntent.ConfirmDelete)

        assertNull(vm.state.value.deletion)
        assertEquals(listOf("kopi" to null), categories.deletions)
        assertEquals(
            CategoriesEffect.ShowMessage(UiText.Resource(R.string.categories_deleted, "Kopi")),
            effects.single(),
        )
    }

    @Test
    fun `a category in use asks where its transactions go, other first`() = runCategoriesTest { vm, _ ->
        categories.categoriesInUse += "kopi"

        send(vm, CategoriesIntent.Delete("kopi"), CategoriesIntent.ConfirmDelete)

        val deletion = vm.state.value.deletion!!
        assertTrue(deletion.needsTarget)
        assertEquals(listOf("food", "transport", "other"), deletion.targets.map { it.id })
        assertEquals("other", deletion.targetId)

        send(vm, CategoriesIntent.PickTarget("food"), CategoriesIntent.ConfirmDelete)

        assertEquals(listOf("kopi" to null, "kopi" to "food"), categories.deletions)
        assertNull(vm.state.value.deletion)
    }

    @Test
    fun `default and system categories can't be deleted`() = runCategoriesTest { vm, _ ->
        send(vm, CategoriesIntent.Delete("food"), CategoriesIntent.Delete("other"))

        assertNull(vm.state.value.deletion)
    }

    @Test
    fun `add and edit open the form`() = runCategoriesTest { vm, effects ->
        send(
            vm,
            CategoriesIntent.Add,
            CategoriesIntent.Edit("kopi"),
            CategoriesIntent.Edit("other"),
        )

        assertEquals(
            listOf(
                CategoriesEffect.Navigate(CategoriesDestination.New(CategoryType.EXPENSE)),
                CategoriesEffect.Navigate(CategoriesDestination.Edit(CategoryType.EXPENSE, "kopi")),
            ),
            effects,
        )
    }
}
