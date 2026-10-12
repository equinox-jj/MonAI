package com.djtech.monai.feature.home.presentation.home

import androidx.lifecycle.SavedStateHandle
import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.breakdown
import com.djtech.monai.core.model.budget
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.report
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.user
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.home.presentation.home.mapper.MAX_SPENDING_SLICES
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import com.djtech.monai.feature.home.presentation.home.model.TransactionDay
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.ObserveRecentTransactionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshRecentTransactionsUseCase
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import kotlinx.coroutines.CompletableDeferred
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
import java.time.Instant
import java.time.LocalDate
import java.time.LocalTime
import java.time.YearMonth

class HomeViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val clock = FixedAppClock(NOW)
    private val savedState = SavedStateHandle()
    private val profile = FakeProfileRepository(user())
    private val wallets = FakeWalletRepository(
        listOf(
            wallet("bca", "BCA Tabungan", balance = 8_250_000, isDefault = true),
            wallet("gopay", "GoPay", balance = 1_185_000),
            wallet("dana", "Dana", balance = 50_000, isArchived = true),
        ),
    )
    private val categories = FakeCategoryRepository(
        listOf(category("food", "Food", icon = "restaurant", color = "#F97316")),
    )
    private val transactions = FakeTransactionRepository()
    private val budgets = FakeBudgetRepository()
    private val reports = FakeReportRepository()

    private val viewModel by lazy { viewModel() }
    private val state get() = viewModel.state.value

    private fun viewModel() = HomeViewModel(
        observeUser = ObserveUserUseCase(profile),
        refreshUser = RefreshUserUseCase(profile),
        observeAllWallets = ObserveAllWalletsUseCase(wallets),
        refreshWallets = RefreshWalletsUseCase(wallets),
        observeCategories = ObserveCategoriesUseCase(categories),
        refreshCategories = RefreshCategoriesUseCase(categories),
        observeRecentTransactions = ObserveRecentTransactionsUseCase(transactions),
        refreshRecentTransactions = RefreshRecentTransactionsUseCase(transactions),
        observeBudget = ObserveBudgetUseCase(budgets),
        refreshBudget = RefreshBudgetUseCase(budgets),
        observeMonthlyReport = ObserveMonthlyReportUseCase(reports),
        refreshMonthlyReport = RefreshMonthlyReportUseCase(reports),
        clock = clock,
        savedState = savedState,
    )

    private fun runHomeTest(block: suspend TestScope.() -> Unit) = runTest(mainDispatcherRule.dispatcher) {
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        block()
    }

    private fun TestScope.collectEffects(): List<HomeEffect> {
        val effects = mutableListOf<HomeEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        return effects
    }

    @Test
    fun `refreshes every section for the current month on start`() = runHomeTest {
        advanceUntilIdle()

        assertEquals(1, profile.refreshCount)
        assertEquals(1, wallets.refreshCount)
        assertEquals(1, categories.refreshCount)
        assertEquals(listOf(OCTOBER to RECENT_TRANSACTION_LIMIT), transactions.refreshes)
        assertEquals(listOf(OCTOBER), budgets.refreshedMonths)
        assertEquals(listOf(OCTOBER), reports.refreshedMonths)
        assertEquals(OCTOBER, state.month)
    }

    @Test
    fun `shows the cached user and wallets without the archived one`() = runHomeTest {
        advanceUntilIdle()

        assertFalse(state.isLoading)
        assertEquals("Joshua Putra", state.userName)
        assertEquals("JP", state.initials)
        assertEquals(listOf("bca", "gopay"), state.wallets.map { it.id })
        assertEquals(9_435_000, state.totalBalance)
    }

    @Test
    fun `initials take the first letters of the first two words`() = runHomeTest {
        profile.user.value = user(name = "  joshua  ")
        advanceUntilIdle()
        assertEquals("J", state.initials)

        profile.user.value = user(name = "Joshua Putra Jeremia")
        advanceUntilIdle()
        assertEquals("JP", state.initials)
    }

    @Test
    fun `shows the skeleton while the first load runs with nothing cached`() = runHomeTest {
        profile.user.value = null
        wallets.wallets.value = emptyList()
        val gate = CompletableDeferred<Unit>().also { wallets.gate = it }
        advanceUntilIdle()

        assertTrue(state.isLoading)

        profile.user.value = user()
        gate.complete(Unit)
        advanceUntilIdle()

        assertFalse(state.isLoading)
        assertNull(state.loadError)
    }

    @Test
    fun `a first load that fails with nothing cached shows the error instead of the dashboard`() = runHomeTest {
        profile.user.value = null
        wallets.wallets.value = emptyList()
        profile.refreshResult = Outcome.Failure(ProfileError.Network)
        val effects = collectEffects()
        advanceUntilIdle()

        assertFalse(state.isLoading)
        assertEquals(UiText.Resource(R.string.home_load_failed_network), state.loadError)
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `retrying after a failed first load shows the skeleton again, then the dashboard`() = runHomeTest {
        profile.user.value = null
        wallets.wallets.value = emptyList()
        profile.refreshResult = Outcome.Failure(ProfileError.Unexpected)
        advanceUntilIdle()
        assertEquals(UiText.Resource(R.string.home_load_failed_unexpected), state.loadError)

        profile.refreshResult = Outcome.Success(Unit)
        val gate = CompletableDeferred<Unit>().also { wallets.gate = it }
        viewModel.onIntent(HomeIntent.Refresh)
        advanceUntilIdle()

        assertTrue(state.isLoading)
        assertNull(state.loadError)

        profile.user.value = user()
        gate.complete(Unit)
        advanceUntilIdle()

        assertFalse(state.isLoading)
        assertNull(state.loadError)
    }

    @Test
    fun `a failed refresh with cached data keeps it and says so once`() = runHomeTest {
        reports.refreshResult = Outcome.Failure(ReportError.Unexpected)
        val effects = collectEffects()
        advanceUntilIdle()

        assertNull(state.loadError)
        assertEquals("Joshua Putra", state.userName)
        assertEquals(
            listOf(HomeEffect.ShowMessage(UiText.Resource(R.string.home_refresh_failed_unexpected), isOffline = false)),
            effects,
        )
    }

    @Test
    fun `a network failure in any section wins over an unexpected one`() = runHomeTest {
        reports.refreshResult = Outcome.Failure(ReportError.Unexpected)
        wallets.refreshResult = Outcome.Failure(WalletError.Network)
        val effects = collectEffects()
        advanceUntilIdle()

        assertEquals(
            listOf(HomeEffect.ShowMessage(UiText.Resource(R.string.home_refresh_failed_network), isOffline = true)),
            effects,
        )
    }

    @Test
    fun `pull-to-refresh shows the indicator while it runs and ignores repeats`() = runHomeTest {
        advanceUntilIdle()
        val gate = CompletableDeferred<Unit>().also { wallets.gate = it }

        viewModel.onIntent(HomeIntent.Refresh)
        viewModel.onIntent(HomeIntent.Refresh)
        advanceUntilIdle()

        assertTrue(state.isRefreshing)
        assertFalse(state.isLoading)

        gate.complete(Unit)
        advanceUntilIdle()

        assertFalse(state.isRefreshing)
        assertEquals(2, wallets.refreshCount)
    }

    @Test
    fun `the first load in the background does not show the pull indicator`() = runHomeTest {
        wallets.gate = CompletableDeferred()
        advanceUntilIdle()

        assertFalse(state.isRefreshing)
        assertFalse(state.isLoading)
    }

    @Test
    fun `refreshing after the month ends moves every section to the new month`() = runHomeTest {
        advanceUntilIdle()
        clock.instant = Instant.parse("2026-10-31T17:30:00Z") // 00:30 on 1 November in Jakarta

        viewModel.onIntent(HomeIntent.Refresh)
        advanceUntilIdle()

        val november = YearMonth.of(2026, 11)
        assertEquals(november, state.month)
        assertEquals(listOf(OCTOBER, november), budgets.refreshedMonths)
        assertEquals(listOf(OCTOBER, november), reports.refreshedMonths)
        assertEquals(november, transactions.refreshes.last().first)
    }

    @Test
    fun `greets by the time of day in the user's zone`() = runHomeTest {
        transactions.transactions.value = listOf(transaction("t1"))
        val cases = listOf(
            "2026-10-09T22:00:00Z" to Greeting.MORNING, // 05:00
            "2026-10-10T04:59:00Z" to Greeting.MORNING, // 11:59
            "2026-10-10T05:00:00Z" to Greeting.AFTERNOON, // 12:00
            "2026-10-10T10:59:00Z" to Greeting.AFTERNOON, // 17:59
            "2026-10-10T11:00:00Z" to Greeting.EVENING, // 18:00
            "2026-10-09T21:59:00Z" to Greeting.EVENING, // 04:59
        )
        advanceUntilIdle()

        for ((instant, greeting) in cases) {
            clock.instant = Instant.parse(instant)
            viewModel.onIntent(HomeIntent.Refresh)
            advanceUntilIdle()
            assertEquals(instant, greeting, state.greeting)
        }
    }

    @Test
    fun `welcomes the user when nothing is recorded this month`() = runHomeTest {
        advanceUntilIdle()

        assertEquals(Greeting.WELCOME, state.greeting)
    }

    @Test
    fun `summarises the month from its report`() = runHomeTest {
        reports.reports.value = mapOf(OCTOBER to report())
        advanceUntilIdle()

        assertEquals(
            MonthSummary(
                incomeTotal = 8_500_000,
                expenseTotal = 2_415_000,
                expenseChangePercent = -10.0,
                previousMonth = YearMonth.of(2026, 9),
            ),
            state.summary,
        )
    }

    @Test
    fun `shows the budget with the days left in the month`() = runHomeTest {
        budgets.budgets.value = mapOf(OCTOBER to budget())
        advanceUntilIdle()

        assertEquals(BudgetCard.Set(budget(), daysLeft = 21), state.budget)
    }

    @Test
    fun `prompts for a budget once the month is known to have none`() = runHomeTest {
        assertNull(state.budget)

        advanceUntilIdle()

        assertEquals(BudgetCard.NotSet, state.budget)
    }

    @Test
    fun `hides the budget card when it could not be loaded`() = runHomeTest {
        budgets.refreshResult = Outcome.Failure(BudgetError.Network)
        advanceUntilIdle()

        assertNull(state.budget)
    }

    @Test
    fun `keeps up to five spending slices`() = runHomeTest {
        val five = listOf(
            breakdown("food", 500, 50.0, "#F97316"),
            breakdown("bills", 200, 20.0),
            breakdown("transport", 150, 15.0),
            breakdown("shopping", 100, 10.0),
            breakdown("health", 50, 5.0),
        )
        reports.reports.value = mapOf(OCTOBER to report(categories = five))
        advanceUntilIdle()

        assertEquals(
            listOf("food", "bills", "transport", "shopping", "health"),
            state.spending.map { it.categoryId },
        )
        assertEquals(SpendingSlice("food", UiText.Dynamic("food"), "#F97316", 500, 50.0), state.spending.first())
    }

    @Test
    fun `groups the smaller categories into others and drops empty ones`() = runHomeTest {
        val categories = listOf(
            breakdown("food", 400, 40.0),
            breakdown("bills", 200, 20.0),
            breakdown("transport", 150, 15.0),
            breakdown("shopping", 100, 10.0),
            breakdown("health", 90, 9.0),
            breakdown("gifts", 60, 6.0),
            breakdown("pets", 0, 0.0),
        )
        reports.reports.value = mapOf(OCTOBER to report(categories = categories))
        advanceUntilIdle()

        assertEquals(MAX_SPENDING_SLICES, state.spending.size)
        assertEquals(
            SpendingSlice(null, UiText.Resource(R.string.home_spending_others), null, 150, 15.0),
            state.spending.last(),
        )
    }

    @Test
    fun `labels recent transactions with their category and wallets`() = runHomeTest {
        transactions.transactions.value = listOf(
            transaction("t3", note = "Makan siang", merchant = "Warteg"),
            transaction("t2", merchant = "Indomaret", walletId = "dana"),
            transaction("t1", note = " ", categoryId = "unknown"),
        )
        advanceUntilIdle()

        val (lunch, shop, untitled) = state.recent
        assertEquals(UiText.Dynamic("Makan siang"), lunch.title)
        assertEquals("Food", lunch.categoryName)
        assertEquals("restaurant", lunch.icon)
        assertEquals("#F97316", lunch.color)
        assertEquals("BCA Tabungan", lunch.walletName)
        assertEquals(UiText.Dynamic("Indomaret"), shop.title)
        assertEquals("Dana", shop.walletName)
        assertEquals(UiText.Resource(R.string.home_transaction_untitled), untitled.title)
        assertNull(untitled.categoryName)
    }

    @Test
    fun `falls back to the category name, and to transfer for a transfer`() = runHomeTest {
        transactions.transactions.value = listOf(
            transaction("t2"),
            transaction(
                "t1",
                type = TransactionType.TRANSFER,
                categoryId = null,
                walletId = "bca",
                toWalletId = "gopay",
                amount = 500_000,
            ),
        )
        advanceUntilIdle()

        val (expense, transfer) = state.recent
        assertEquals(UiText.Dynamic("Food"), expense.title)
        assertEquals(UiText.Resource(R.string.home_transaction_transfer), transfer.title)
        assertEquals(TransactionType.TRANSFER, transfer.type)
        assertEquals("BCA Tabungan", transfer.walletName)
        assertEquals("GoPay", transfer.toWalletName)
    }

    @Test
    fun `dates recent transactions relative to today`() = runHomeTest {
        transactions.transactions.value = listOf(
            transaction("t3", createdAt = Instant.parse("2026-10-10T02:15:00Z")),
            transaction("t2", date = LocalDate.of(2026, 10, 9)),
            transaction("t1", date = LocalDate.of(2026, 10, 7)),
        )
        advanceUntilIdle()

        assertEquals(
            listOf(
                TransactionDay.Today(LocalTime.of(9, 15)),
                TransactionDay.Yesterday,
                TransactionDay.Earlier(LocalDate.of(2026, 10, 7)),
            ),
            state.recent.map { it.day },
        )
    }

    @Test
    fun `toggling hides the balance and survives process death`() = runHomeTest {
        viewModel.onIntent(HomeIntent.ToggleBalanceVisibility)
        advanceUntilIdle()
        assertTrue(state.isBalanceHidden)

        val restored = viewModel()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { restored.state.collect {} }
        advanceUntilIdle()
        assertTrue(restored.state.value.isBalanceHidden)

        viewModel.onIntent(HomeIntent.ToggleBalanceVisibility)
        advanceUntilIdle()
        assertFalse(state.isBalanceHidden)
    }

    @Test
    fun `opening a destination navigates to it`() = runHomeTest {
        val effects = collectEffects()
        advanceUntilIdle()

        viewModel.onIntent(HomeIntent.Open(HomeDestination.WalletDetail("bca")))
        advanceUntilIdle()

        assertEquals(listOf(HomeEffect.Navigate(HomeDestination.WalletDetail("bca"))), effects)
    }
}
