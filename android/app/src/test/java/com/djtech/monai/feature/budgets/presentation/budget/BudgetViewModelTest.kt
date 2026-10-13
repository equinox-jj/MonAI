package com.djtech.monai.feature.budgets.presentation.budget

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.budget
import com.djtech.monai.core.model.report
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.budgets.domain.usecase.DeleteBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.SetBudgetUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
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

class BudgetViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val budgets = FakeBudgetRepository()
    private val reports = FakeReportRepository(report(expense = 2_415_000))

    private fun viewModel() = BudgetViewModel(
        month = OCTOBER,
        observeBudget = ObserveBudgetUseCase(budgets),
        refreshBudget = RefreshBudgetUseCase(budgets),
        observeMonthlyReport = ObserveMonthlyReportUseCase(reports),
        refreshMonthlyReport = RefreshMonthlyReportUseCase(reports),
        setBudget = SetBudgetUseCase(budgets),
        deleteBudget = DeleteBudgetUseCase(budgets),
    )

    private fun runBudgetTest(block: suspend TestScope.(BudgetViewModel, MutableList<BudgetEffect>) -> Unit) =
        runTest(mainDispatcherRule.dispatcher) {
            val viewModel = viewModel()
            val effects = mutableListOf<BudgetEffect>()
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
            advanceUntilIdle()
            block(viewModel, effects)
        }

    private fun TestScope.send(viewModel: BudgetViewModel, vararg intents: BudgetIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `refreshes the month's budget and report`() = runBudgetTest { _, _ ->
        assertEquals(listOf(OCTOBER), budgets.refreshedMonths)
        assertEquals(listOf(OCTOBER), reports.refreshedMonths)
    }

    @Test
    fun `without a budget the limit starts empty and spending comes from the report`() = runBudgetTest { vm, _ ->
        val state = vm.state.value

        assertEquals(0L, state.limit)
        assertEquals(2_415_000L, state.spent)
        assertFalse(state.hasBudget)
        assertFalse(state.canSave)
        assertNull(state.preview)
    }

    @Test
    fun `a saved budget fills the limit and its spending`() = runBudgetTest { vm, _ ->
        budgets.budgets.value = mapOf(OCTOBER to budget(limit = 3_000_000, spent = 2_500_000))
        advanceUntilIdle()

        val state = vm.state.value
        assertEquals(3_000_000L, state.limit)
        assertEquals(2_500_000L, state.spent)
        assertTrue(state.hasBudget)
    }

    @Test
    fun `typing a limit previews it against the month's spending`() = runBudgetTest { vm, _ ->
        send(vm, BudgetIntent.LimitChanged(3_000_000))

        val preview = vm.state.value.preview
        assertEquals(80, preview?.percent)
        assertEquals(BudgetStatus.WARNING, preview?.status)
        assertEquals(585_000L, preview?.remaining)
        assertTrue(vm.state.value.canSave)
    }

    @Test
    fun `a typed limit is kept when the saved budget arrives later`() = runBudgetTest { vm, _ ->
        send(vm, BudgetIntent.LimitChanged(4_000_000))
        budgets.budgets.value = mapOf(OCTOBER to budget(limit = 3_000_000))
        advanceUntilIdle()

        assertEquals(4_000_000L, vm.state.value.limit)
    }

    @Test
    fun `a preset replaces the limit`() = runBudgetTest { vm, _ ->
        send(vm, BudgetIntent.LimitChanged(1_234), BudgetIntent.PickPreset(2_500_000))

        assertEquals(2_500_000L, vm.state.value.limit)
    }

    @Test
    fun `saving sets the month's budget and closes`() = runBudgetTest { vm, effects ->
        send(vm, BudgetIntent.LimitChanged(3_000_000), BudgetIntent.Save)

        assertEquals(listOf(OCTOBER to 3_000_000L), budgets.setBudgets)
        assertEquals(listOf(BudgetEffect.Close), effects)
    }

    @Test
    fun `a refused limit is shown on the field`() = runBudgetTest { vm, effects ->
        budgets.setResult = Outcome.Failure(BudgetError.InvalidLimit)

        send(vm, BudgetIntent.LimitChanged(3_000_000), BudgetIntent.Save)

        assertEquals(UiText.Resource(R.string.budget_error_invalid_limit), vm.state.value.limitError)
        assertFalse(vm.state.value.isSaving)
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `typing again clears the limit error`() = runBudgetTest { vm, _ ->
        budgets.setResult = Outcome.Failure(BudgetError.InvalidLimit)
        send(vm, BudgetIntent.LimitChanged(3_000_000), BudgetIntent.Save)
        send(vm, BudgetIntent.LimitChanged(30_000))

        assertNull(vm.state.value.limitError)
    }

    @Test
    fun `saving offline says so and stays open`() = runBudgetTest { vm, effects ->
        budgets.setResult = Outcome.Failure(BudgetError.Network)

        send(vm, BudgetIntent.LimitChanged(3_000_000), BudgetIntent.Save)

        assertEquals(listOf(BudgetEffect.ShowMessage(UiText.Resource(R.string.budget_error_network))), effects)
    }

    @Test
    fun `saving with an empty limit does nothing`() = runBudgetTest { vm, effects ->
        send(vm, BudgetIntent.Save)

        assertTrue(budgets.setBudgets.isEmpty())
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `removing asks first and deletes the month's budget on confirm`() = runBudgetTest { vm, effects ->
        budgets.budgets.value = mapOf(OCTOBER to budget())
        send(vm, BudgetIntent.Delete)

        assertTrue(vm.state.value.isConfirmingDelete)
        assertTrue(budgets.deletedMonths.isEmpty())

        send(vm, BudgetIntent.ConfirmDelete)

        assertFalse(vm.state.value.isConfirmingDelete)
        assertEquals(listOf(OCTOBER), budgets.deletedMonths)
        assertEquals(listOf(BudgetEffect.Close), effects)
    }

    @Test
    fun `dismissing the confirmation keeps the budget`() = runBudgetTest { vm, _ ->
        budgets.budgets.value = mapOf(OCTOBER to budget())
        send(vm, BudgetIntent.Delete, BudgetIntent.DismissDelete)

        assertFalse(vm.state.value.isConfirmingDelete)
        assertTrue(budgets.deletedMonths.isEmpty())
    }

    @Test
    fun `a failed removal says so`() = runBudgetTest { vm, effects ->
        budgets.budgets.value = mapOf(OCTOBER to budget())
        budgets.deleteResult = Outcome.Failure(BudgetError.Unexpected)

        send(vm, BudgetIntent.Delete, BudgetIntent.ConfirmDelete)

        assertEquals(listOf(BudgetEffect.ShowMessage(UiText.Resource(R.string.budget_error_unexpected))), effects)
        assertFalse(vm.state.value.isDeleting)
    }

    @Test
    fun `back closes`() = runBudgetTest { vm, effects ->
        send(vm, BudgetIntent.Back)

        assertEquals(listOf(BudgetEffect.Close), effects)
    }
}
