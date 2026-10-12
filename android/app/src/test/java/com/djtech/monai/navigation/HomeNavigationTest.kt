package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import org.junit.Assert.assertEquals
import org.junit.Test

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
    fun `destinations without a screen yet stay on home`() {
        val unbuilt = listOf(
            HomeDestination.QuickAdd,
            HomeDestination.ScanReceipt,
            HomeDestination.WalletDetail("bca"),
            HomeDestination.AddWallet,
            HomeDestination.Budget,
            HomeDestination.Report,
        )

        unbuilt.forEach(navigator::openFromHome)

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }
}
