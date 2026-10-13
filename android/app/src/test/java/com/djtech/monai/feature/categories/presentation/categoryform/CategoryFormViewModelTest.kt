package com.djtech.monai.feature.categories.presentation.categoryform

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.category
import com.djtech.monai.feature.categories.domain.event.CategoryCreationEvents
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.CreateCategoryUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.UpdateCategoryUseCase
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice
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

class CategoryFormViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val categories = FakeCategoryRepository()

    private fun runFormTest(
        type: CategoryType = CategoryType.EXPENSE,
        categoryId: String? = null,
        block: suspend TestScope.(CategoryFormViewModel, MutableList<CategoryFormEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = CategoryFormViewModel(
            type,
            categoryId,
            CreateCategoryUseCase(categories, CategoryCreationEvents()),
            UpdateCategoryUseCase(categories),
            ObserveCategoriesUseCase(categories),
        )
        val effects = mutableListOf<CategoryFormEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: CategoryFormViewModel, vararg intents: CategoryFormIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `starts empty with the first icon and color, and can't save yet`() = runFormTest(CategoryType.INCOME) { vm, _ ->
        val state = vm.state.value

        assertEquals(CategoryType.INCOME, state.type)
        assertEquals("", state.name)
        assertEquals(CategoryIconChoice.entries.first(), state.icon)
        assertEquals(CategoryColorChoice.entries.first(), state.color)
        assertFalse(state.canSave)
    }

    @Test
    fun `saving creates the category of the form's type and closes`() = runFormTest { vm, effects ->
        send(
            vm,
            CategoryFormIntent.NameChanged("Kopi"),
            CategoryFormIntent.PickIcon(CategoryIconChoice.Coffee),
            CategoryFormIntent.PickColor(CategoryColorChoice.Indigo),
            CategoryFormIntent.Save,
        )

        assertEquals(
            listOf(
                CategoryInput(
                    name = "Kopi",
                    type = CategoryType.EXPENSE,
                    icon = "local_cafe",
                    color = "#6366F1",
                ),
            ),
            categories.createdInputs,
        )
        assertEquals(listOf(CategoryFormEffect.Close), effects)
    }

    @Test
    fun `the name stops at 30 characters`() = runFormTest { vm, _ ->
        send(vm, CategoryFormIntent.NameChanged("a".repeat(35)))

        assertEquals(30, vm.state.value.name.length)
    }

    @Test
    fun `a taken name is shown on the field and the form stays open`() = runFormTest { vm, effects ->
        categories.createError = CategoryError.InvalidName(CategoryNameIssue.ALREADY_EXISTS)

        send(vm, CategoryFormIntent.NameChanged("Food"), CategoryFormIntent.Save)

        assertEquals(UiText.Resource(R.string.category_form_name_taken), vm.state.value.nameError)
        assertFalse(vm.state.value.isSaving)
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `editing the name clears its error`() = runFormTest { vm, _ ->
        categories.createError = CategoryError.InvalidName(CategoryNameIssue.ALREADY_EXISTS)
        send(vm, CategoryFormIntent.NameChanged("Food"), CategoryFormIntent.Save)

        send(vm, CategoryFormIntent.NameChanged("Food court"))

        assertNull(vm.state.value.nameError)
    }

    @Test
    fun `saving offline says so`() = runFormTest { vm, effects ->
        categories.createError = CategoryError.Network

        send(vm, CategoryFormIntent.NameChanged("Kopi"), CategoryFormIntent.Save)

        assertEquals(
            listOf(CategoryFormEffect.ShowMessage(UiText.Resource(R.string.category_form_error_network))),
            effects,
        )
    }

    @Test
    fun `saving a blank name does nothing`() = runFormTest { vm, effects ->
        send(vm, CategoryFormIntent.NameChanged("   "), CategoryFormIntent.Save)

        assertTrue(categories.createdInputs.isEmpty())
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `close closes`() = runFormTest { vm, effects ->
        send(vm, CategoryFormIntent.Close)

        assertEquals(listOf(CategoryFormEffect.Close), effects)
    }

    @Test
    fun `editing fills the form from the cached category`() = runFormTest(categoryId = "kopi") { vm, _ ->
        // The form reads the cache once the dispatcher runs, so this is in place before it does.
        categories.categories.value = listOf(KOPI)
        assertTrue(vm.state.value.isLoading)
        advanceUntilIdle()
        val state = vm.state.value

        assertTrue(state.isEditing)
        assertFalse(state.isLoading)
        assertEquals("Kopi", state.name)
        assertEquals(CategoryIconChoice.Coffee, state.icon)
        assertEquals(CategoryColorChoice.Indigo, state.color)
    }

    @Test
    fun `saving an edit sends only the changes and closes`() = runFormTest(categoryId = "kopi") { vm, effects ->
        categories.categories.value = listOf(KOPI)
        advanceUntilIdle()

        send(vm, CategoryFormIntent.NameChanged("Coffee"), CategoryFormIntent.Save)

        assertEquals(listOf("kopi" to CategoryChanges(name = "Coffee")), categories.updates)
        assertTrue(categories.createdInputs.isEmpty())
        assertEquals(listOf<CategoryFormEffect>(CategoryFormEffect.Close), effects)
    }

    @Test
    fun `editing a category that is gone closes the form`() = runFormTest(categoryId = "gone") { _, effects ->
        advanceUntilIdle()

        assertEquals(CategoryFormEffect.Close, effects.last())
    }

    private companion object {
        val KOPI = category(
            "kopi",
            name = "Kopi",
            icon = "local_cafe",
            color = "#6366F1",
            isDefault = false,
        )
    }
}
