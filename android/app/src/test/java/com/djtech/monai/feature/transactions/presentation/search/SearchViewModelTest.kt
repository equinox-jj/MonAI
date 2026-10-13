package com.djtech.monai.feature.transactions.presentation.search

import androidx.paging.testing.asSnapshot
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.SearchHistoryStore
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.reports.domain.usecase.ObserveCachedExpenseTotalsUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.SearchTransactionsUseCase
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate
import java.time.YearMonth

class SearchViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val transactions = FakeTransactionRepository(
        listOf(
            transaction("kopi-oct", note = "Kopi susu"),
            transaction("kopi-sep", LocalDate.of(2026, 9, 3), note = "Biji kopi"),
            transaction("parkir", note = "Parkir"),
        ),
    )
    private val history = SearchHistoryStore(InMemoryPreferencesDataStore())

    private fun viewModel(month: String? = null) = SearchViewModel(
        initialMonth = month,
        searchTransactions = SearchTransactionsUseCase(transactions),
        observeCategories = ObserveCategoriesUseCase(FakeCategoryRepository(listOf(category("food")))),
        observeVisibleCategories = ObserveVisibleCategoriesUseCase(FakeCategoryRepository(listOf(category("food")))),
        observeAllWallets = ObserveAllWalletsUseCase(FakeWalletRepository(listOf(wallet("bca")))),
        observeCachedExpenseTotals = ObserveCachedExpenseTotalsUseCase(FakeReportRepository()),
        searchHistoryStore = history,
        clock = FixedAppClock(NOW),
    )

    private fun runSearchTest(
        month: String? = null,
        block: suspend TestScope.(SearchViewModel, MutableList<SearchEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = viewModel(month)
        val effects = mutableListOf<SearchEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    // The results flow never completes, and asSnapshot needs one that does.
    private suspend fun SearchViewModel.snapshot() = results.take(1).asSnapshot().map(Transaction::id)

    @Test
    fun `searches the list's month once typing pauses`() = runSearchTest("2026-10") { vm, _ ->
        vm.onIntent(SearchIntent.QueryChanged("k"))
        vm.onIntent(SearchIntent.QueryChanged("kopi"))
        advanceTimeBy(SEARCH_DEBOUNCE_MS + 1)
        advanceUntilIdle()

        assertEquals(listOf("kopi-oct"), vm.snapshot())
        assertEquals(listOf(Triple("kopi", OCTOBER, TransactionFilter())), transactions.searches)
        assertEquals("kopi", vm.state.value.query)
    }

    @Test
    fun `searching all months looks through every cached month`() = runSearchTest { vm, _ ->
        vm.onIntent(SearchIntent.QueryChanged("kopi"))
        vm.onIntent(SearchIntent.SearchAllMonths)
        advanceUntilIdle()

        assertTrue(vm.state.value.allMonths)
        assertEquals(listOf("kopi-oct", "kopi-sep"), vm.snapshot())

        vm.onIntent(SearchIntent.SearchMonthOnly)
        advanceUntilIdle()
        assertFalse(vm.state.value.allMonths)
    }

    @Test
    fun `starts on the month the list showed, never a future one`() {
        runSearchTest("2026-08") { vm, _ -> assertEquals(YearMonth.of(2026, 8), vm.state.value.month) }
        runSearchTest("2027-01") { vm, _ -> assertEquals(OCTOBER, vm.state.value.month) }
    }

    @Test
    fun `picking a month searches that month`() = runSearchTest { vm, _ ->
        vm.onIntent(SearchIntent.SearchAllMonths)
        vm.onIntent(SearchIntent.Filter(FilterIntent.Open(FilterSheetKind.MONTH)))
        vm.onIntent(SearchIntent.Filter(FilterIntent.PickMonth(YearMonth.of(2026, 9))))
        vm.onIntent(SearchIntent.Filter(FilterIntent.Apply))
        advanceUntilIdle()

        assertEquals(YearMonth.of(2026, 9), vm.state.value.month)
        assertFalse(vm.state.value.allMonths)
    }

    @Test
    fun `submitting and opening a result keep the text in recent searches`() = runSearchTest { vm, effects ->
        vm.onIntent(SearchIntent.QueryChanged("parkir"))
        vm.onIntent(SearchIntent.Submit)
        vm.onIntent(SearchIntent.QueryChanged("kopi"))
        vm.onIntent(SearchIntent.OpenResult("kopi-oct"))
        advanceUntilIdle()

        assertEquals(listOf("kopi", "parkir"), history.recentSearches.first())
        assertEquals(listOf("kopi", "parkir"), vm.state.value.recentSearches)
        assertEquals(listOf<SearchEffect>(SearchEffect.OpenTransaction("kopi-oct")), effects)
    }

    @Test
    fun `a recent search fills the field and searches it`() = runSearchTest { vm, _ ->
        history.add("parkir")

        vm.onIntent(SearchIntent.UseRecent("parkir"))
        advanceTimeBy(SEARCH_DEBOUNCE_MS + 1)
        advanceUntilIdle()

        assertEquals("parkir", vm.state.value.query)
        assertEquals(listOf("parkir"), vm.snapshot())
    }

    @Test
    fun `clearing the text shows nothing`() = runSearchTest { vm, _ ->
        vm.onIntent(SearchIntent.QueryChanged("kopi"))
        advanceTimeBy(SEARCH_DEBOUNCE_MS + 1)
        vm.onIntent(SearchIntent.ClearQuery)
        advanceUntilIdle()

        assertEquals("", vm.state.value.query)
        assertEquals(emptyList<String>(), vm.snapshot())
    }

    @Test
    fun `back navigates back`() = runSearchTest { vm, effects ->
        vm.onIntent(SearchIntent.Back)
        advanceUntilIdle()

        assertEquals(listOf<SearchEffect>(SearchEffect.NavigateBack), effects)
    }
}
