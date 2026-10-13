package com.djtech.monai.feature.transactions.presentation.transactions

import androidx.paging.testing.asSnapshot
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.report
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.reports.domain.usecase.ObserveCachedExpenseTotalsUseCase
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.transactions.domain.event.TransactionDeletionEvents
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveDailyNetsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionDeletionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionDependentsUseCase
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate
import java.time.YearMonth

class TransactionsViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val clock = FixedAppClock(NOW)
    private val wallets = FakeWalletRepository(listOf(wallet("bca"), wallet("ovo", isArchived = true)))
    private val categories = FakeCategoryRepository(
        listOf(
            category("food"),
            category("old", isHidden = true),
            category("salary", type = CategoryType.INCOME),
        ),
    )
    private val reports = FakeReportRepository(report(income = 8_500_000, expense = 2_415_000))
    private val transactions = FakeTransactionRepository(
        listOf(
            transaction("lunch", LocalDate.of(2026, 10, 10)),
            transaction("bus", LocalDate.of(2026, 10, 9), walletId = "gopay"),
            transaction("sept", LocalDate.of(2026, 9, 30)),
        ),
    )

    private val deletionEvents = TransactionDeletionEvents()

    private val viewModel by lazy {
        TransactionsViewModel(
            observeTransactions = ObserveTransactionsUseCase(transactions),
            observeDailyNets = ObserveDailyNetsUseCase(transactions),
            deleteTransaction = DeleteTransactionUseCase(
                transactions,
                deletionEvents,
                RefreshTransactionDependentsUseCase(wallets, reports, FakeBudgetRepository()),
            ),
            observeTransactionDeletions = ObserveTransactionDeletionsUseCase(deletionEvents),
            observeAllWallets = ObserveAllWalletsUseCase(wallets),
            refreshWallets = RefreshWalletsUseCase(wallets),
            observeCategories = ObserveCategoriesUseCase(categories),
            observeVisibleCategories = ObserveVisibleCategoriesUseCase(categories),
            refreshCategories = RefreshCategoriesUseCase(categories),
            observeMonthlyReport = ObserveMonthlyReportUseCase(reports),
            refreshMonthlyReport = RefreshMonthlyReportUseCase(reports),
            observeCachedExpenseTotals = ObserveCachedExpenseTotalsUseCase(reports),
            clock = clock,
        )
    }
    private val state get() = viewModel.state.value

    private fun runListTest(block: suspend TestScope.() -> Unit) = runTest(mainDispatcherRule.dispatcher) {
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        block()
    }

    // The ViewModel's flow never completes, and asSnapshot needs one that does.
    private suspend fun snapshot() = viewModel.transactions.take(1).asSnapshot()

    private fun TestScope.collectEffects(): List<TransactionsEffect> {
        val effects = mutableListOf<TransactionsEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        return effects
    }

    @Test
    fun `opens on the current month and refreshes the names and totals around the list`() = runListTest {
        advanceUntilIdle()

        assertEquals(OCTOBER, state.month)
        assertEquals(OCTOBER, state.currentMonth)
        assertEquals(1, wallets.refreshCount)
        assertEquals(1, categories.refreshCount)
        assertEquals(listOf(OCTOBER), reports.refreshedMonths)
        assertEquals(MonthTotals(income = 8_500_000, expense = 2_415_000), state.totals)
    }

    @Test
    fun `lists the month newest first with a header above each day`() = runListTest {
        advanceUntilIdle()
        val items = snapshot()

        assertEquals(
            listOf("day-2026-10-10", "lunch", "day-2026-10-09", "bus"),
            items.map(TransactionListItem::key),
        )
        assertEquals(
            mapOf(LocalDate.of(2026, 10, 10) to -35_000L, LocalDate.of(2026, 10, 9) to -35_000L),
            state.dailyNets,
        )
    }

    @Test
    fun `filter sheets offer every wallet and the categories that aren't hidden`() = runListTest {
        advanceUntilIdle()

        assertEquals(listOf("bca", "ovo"), state.wallets.map { it.id })
        assertEquals(listOf("food", "salary"), state.categories.map { it.id })
        assertEquals("old", state.lookups.category("old")?.id)
    }

    @Test
    fun `previous month moves back and refreshes that month's report`() = runListTest {
        viewModel.onIntent(TransactionsIntent.PreviousMonth)
        advanceUntilIdle()

        assertEquals(YearMonth.of(2026, 9), state.month)
        assertEquals(listOf("day-2026-09-30", "sept"), snapshot().map(TransactionListItem::key))
        assertEquals(listOf(OCTOBER, YearMonth.of(2026, 9)), reports.refreshedMonths)
        assert(state.canShowNextMonth)
    }

    @Test
    fun `next month stops at the current month`() = runListTest {
        viewModel.onIntent(TransactionsIntent.NextMonth)
        advanceUntilIdle()

        assertEquals(OCTOBER, state.month)
        assertFalse(state.canShowNextMonth)
    }

    @Test
    fun `an applied filter narrows the list`() = runListTest {
        viewModel.onIntent(TransactionsIntent.Filter(FilterIntent.Open(FilterSheetKind.WALLET)))
        viewModel.onIntent(TransactionsIntent.Filter(FilterIntent.PickWallet("gopay")))
        advanceUntilIdle()
        assertEquals(FilterSheet.Wallet("gopay"), state.sheet)

        viewModel.onIntent(TransactionsIntent.Filter(FilterIntent.Apply))
        advanceUntilIdle()

        assertEquals(TransactionFilter(walletId = "gopay"), state.filter)
        assertNull(state.sheet)
        assertEquals(listOf("day-2026-10-09", "bus"), snapshot().map(TransactionListItem::key))
    }

    @Test
    fun `the month picker shows what was spent in the year's cached months`() = runListTest {
        reports.reports.value += YearMonth.of(2026, 3) to report(month = YearMonth.of(2026, 3), expense = 1_900_000)

        viewModel.onIntent(TransactionsIntent.Filter(FilterIntent.Open(FilterSheetKind.MONTH)))
        advanceUntilIdle()

        assertEquals(mapOf(OCTOBER to 2_415_000L, YearMonth.of(2026, 3) to 1_900_000L), state.monthPickerTotals)
    }

    @Test
    fun `delete removes the transaction through the use case`() = runListTest {
        viewModel.onIntent(TransactionsIntent.Delete("lunch"))
        advanceUntilIdle()

        assertEquals(listOf("lunch"), transactions.deletedIds)
    }

    @Test
    fun `a failed delete says why`() = runListTest {
        val effects = collectEffects()
        transactions.deleteResult = Outcome.Failure(TransactionError.Network)

        viewModel.onIntent(TransactionsIntent.Delete("lunch"))
        advanceUntilIdle()

        assertEquals(
            listOf(
                TransactionsEffect.ShowMessage(UiText.Resource(R.string.transaction_error_network), isOffline = true),
            ),
            effects,
        )
    }

    @Test
    fun `deleting the selected transaction empties the detail pane`() = runListTest {
        viewModel.onIntent(TransactionsIntent.Select("lunch"))
        advanceUntilIdle()
        assertEquals("lunch", state.selectedId)

        viewModel.onIntent(TransactionsIntent.Delete("lunch"))
        advanceUntilIdle()

        assertNull(state.selectedId)
    }

    @Test
    fun `changing month clears the selection`() = runListTest {
        viewModel.onIntent(TransactionsIntent.Select("lunch"))
        viewModel.onIntent(TransactionsIntent.PreviousMonth)
        advanceUntilIdle()

        assertNull(state.selectedId)
    }

    @Test
    fun `open navigates`() = runListTest {
        val effects = collectEffects()

        viewModel.onIntent(TransactionsIntent.Open(TransactionsDestination.Detail("lunch")))
        advanceUntilIdle()

        assertEquals(listOf(TransactionsEffect.Navigate(TransactionsDestination.Detail("lunch"))), effects)
    }
}
