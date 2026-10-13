package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.YearMonth

private val OCTOBER: YearMonth = YearMonth.of(2026, 10)

class HomeNavigationTest {

    private val navigator = MainNavigator(
        stacks = TopLevelDestination.entries.associateWith { NavBackStack<NavKey>(it.route) },
        currentTab = mutableStateOf(TopLevelDestination.Home),
    )

    @Test
    fun `see-all transactions opens the transactions tab`() {
        navigator.openFromHome(HomeDestination.Transactions)

        assertEquals(TopLevelDestination.Transactions, navigator.currentTab)
    }

    @Test
    fun `search, a recent transaction and add open on top of home`() {
        navigator.openFromHome(HomeDestination.Search)
        navigator.openFromHome(HomeDestination.TransactionDetail("t1"))
        navigator.openFromHome(HomeDestination.AddTransaction)

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(
            listOf(HomeRoute, TransactionSearchRoute(), TransactionDetailRoute("t1"), TransactionFormRoute()),
            navigator.backStack,
        )
    }

    @Test
    fun `see-all wallets and the avatar open their tabs`() {
        navigator.openFromHome(HomeDestination.Wallets)
        assertEquals(TopLevelDestination.Wallets, navigator.currentTab)

        navigator.selectTab(TopLevelDestination.Home)
        navigator.openFromHome(HomeDestination.Settings)
        assertEquals(TopLevelDestination.Settings, navigator.currentTab)
    }

    @Test
    fun `a wallet card and add wallet open on top of home`() {
        navigator.openFromHome(HomeDestination.WalletDetail("bca"))
        navigator.openFromHome(HomeDestination.AddWallet)

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute, WalletDetailRoute("bca"), WalletFormRoute()), navigator.backStack)
    }

    @Test
    fun `the budget card and full report open home's month on top of home`() {
        navigator.openFromHome(HomeDestination.Budget(OCTOBER))
        navigator.openFromHome(HomeDestination.Report(OCTOBER))

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute, BudgetRoute("2026-10"), ReportRoute("2026-10")), navigator.backStack)
    }

    @Test
    fun `budget and report are full screen`() {
        assertTrue(BudgetRoute("2026-10").isFullScreen())
        assertTrue(ReportRoute().isFullScreen())
    }

    @Test
    fun `destinations without a screen yet stay on home`() {
        val unbuilt = listOf(
            HomeDestination.QuickAdd,
            HomeDestination.ScanReceipt,
        )

        unbuilt.forEach(navigator::openFromHome)

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }
}
