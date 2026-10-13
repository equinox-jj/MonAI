package com.djtech.monai.feature.reports.presentation.report

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.budget
import com.djtech.monai.core.model.breakdown
import com.djtech.monai.core.model.report
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
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
import java.time.YearMonth

class ReportViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val september: YearMonth = OCTOBER.minusMonths(1)
    private val clock = FixedAppClock(NOW)
    private val reports = FakeReportRepository(
        report(
            categories = listOf(
                breakdown("food", amount = 865_000, share = 60.0),
                breakdown("bills", amount = 610_000, share = 40.0),
            ),
        ),
        report(month = september, expense = 2_700_000),
    )
    private val budgets = FakeBudgetRepository(budget())

    private fun viewModel(month: YearMonth? = null) = ReportViewModel(
        initialMonth = month,
        observeMonthlyReport = ObserveMonthlyReportUseCase(reports),
        refreshMonthlyReport = RefreshMonthlyReportUseCase(reports),
        observeBudget = ObserveBudgetUseCase(budgets),
        refreshBudget = RefreshBudgetUseCase(budgets),
        clock = clock,
    )

    private fun runReportTest(
        month: YearMonth? = null,
        block: suspend TestScope.(ReportViewModel, MutableList<ReportEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = viewModel(month)
        val effects = mutableListOf<ReportEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: ReportViewModel, vararg intents: ReportIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `opens on the current month with its report and budget, refreshing both`() = runReportTest { vm, _ ->
        val state = vm.state.value

        assertEquals(OCTOBER, state.month)
        assertFalse(state.isLoading)
        assertEquals(2_415_000L, state.totals?.expense)
        assertEquals(listOf("food", "bills"), state.categories.map { it.categoryId })
        assertEquals(ReportBudgetCard.Set(budget()), state.budget)
        assertEquals(listOf(OCTOBER), reports.refreshedMonths)
        assertEquals(listOf(OCTOBER), budgets.refreshedMonths)
    }

    @Test
    fun `the current month can't go forward`() = runReportTest { vm, _ ->
        assertFalse(vm.state.value.canGoNext)

        send(vm, ReportIntent.NextMonth)

        assertEquals(OCTOBER, vm.state.value.month)
    }

    @Test
    fun `previous month shows and refreshes that month`() = runReportTest { vm, _ ->
        send(vm, ReportIntent.PreviousMonth)

        val state = vm.state.value
        assertEquals(september, state.month)
        assertTrue(state.canGoNext)
        assertEquals(2_700_000L, state.totals?.expense)
        assertEquals(ReportBudgetCard.NotSet, state.budget)
        assertEquals(listOf(OCTOBER, september), reports.refreshedMonths)
        assertEquals(listOf(OCTOBER, september), budgets.refreshedMonths)
    }

    @Test
    fun `next month comes back from an earlier one`() = runReportTest { vm, _ ->
        send(vm, ReportIntent.PreviousMonth, ReportIntent.NextMonth)

        assertEquals(OCTOBER, vm.state.value.month)
    }

    @Test
    fun `can open on an earlier month`() = runReportTest(month = september) { vm, _ ->
        assertEquals(september, vm.state.value.month)
        assertTrue(vm.state.value.canGoNext)
    }

    @Test
    fun `a month without a cached report loads, then fails with a message`() = runTest(mainDispatcherRule.dispatcher) {
        reports.refreshResult = Outcome.Failure(ReportError.Network)
        val vm = viewModel(YearMonth.of(2026, 8))
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        advanceUntilIdle()

        val state = vm.state.value
        assertFalse(state.isLoading)
        assertNull(state.totals)
        assertEquals(UiText.Resource(R.string.report_load_failed_network), state.loadError)
    }

    @Test
    fun `retry refetches the shown month`() = runReportTest { vm, _ ->
        send(vm, ReportIntent.Retry)

        assertEquals(listOf(OCTOBER, OCTOBER), reports.refreshedMonths)
    }

    @Test
    fun `a failed refresh keeps the cached report and says it's offline`() = runTest(mainDispatcherRule.dispatcher) {
        reports.refreshResult = Outcome.Failure(ReportError.Network)
        val vm = viewModel()
        val effects = mutableListOf<ReportEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.effects.toList(effects) }
        advanceUntilIdle()

        assertEquals(2_415_000L, vm.state.value.totals?.expense)
        assertNull(vm.state.value.loadError)
        assertEquals(listOf(ReportEffect.ShowMessage(UiText.Resource(R.string.report_refresh_failed_network))), effects)
    }

    @Test
    fun `the budget card opens the shown month's budget`() = runReportTest { vm, effects ->
        send(vm, ReportIntent.PreviousMonth, ReportIntent.OpenBudget)

        assertEquals(listOf(ReportEffect.OpenBudget(september)), effects)
    }

    @Test
    fun `back navigates back`() = runReportTest { vm, effects ->
        send(vm, ReportIntent.Back)

        assertEquals(listOf(ReportEffect.NavigateBack), effects)
    }
}
