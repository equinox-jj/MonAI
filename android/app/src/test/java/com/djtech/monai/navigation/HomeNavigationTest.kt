package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.receiptDraft
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
    fun `scanning opens on top of home and a saved receipt shows its transaction`() {
        navigator.openFromHome(HomeDestination.ScanReceipt)
        navigator.openReceiptReview("content://camera/1", receiptDraft(), aiFailed = false)

        navigator.showSavedReceipt("t1")

        assertEquals(listOf(HomeRoute, TransactionDetailRoute("t1")), navigator.backStack)
    }

    @Test
    fun `typing instead of scanning swaps the scan for the add form`() {
        navigator.openFromHome(HomeDestination.ScanReceipt)

        navigator.typeInsteadOfScan()

        assertEquals(listOf(HomeRoute, TransactionFormRoute()), navigator.backStack)
    }

    @Test
    fun `typing instead of a scan opened from the add form goes back to that form`() {
        navigator.openFromHome(HomeDestination.AddTransaction)
        navigator.navigate(ScanReceiptRoute)

        navigator.typeInsteadOfScan()

        assertEquals(listOf(HomeRoute, TransactionFormRoute()), navigator.backStack)
    }

    @Test
    fun `quick add opens on top of home`() {
        navigator.openFromHome(HomeDestination.QuickAdd)

        assertEquals(listOf(HomeRoute, QuickAddRoute), navigator.backStack)
    }

    @Test
    fun `saving a drafted transaction closes quick add and its review or form`() {
        navigator.openFromHome(HomeDestination.QuickAdd)
        navigator.openDraftReview("kopi 25rb sama parkir 5rb", listOf(draft(), draft()))

        navigator.closeQuickAdd()
        assertEquals(listOf(HomeRoute), navigator.backStack)

        navigator.openFromHome(HomeDestination.QuickAdd)
        navigator.openDraftForm(draft())
        navigator.closeQuickAdd()
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }
}
