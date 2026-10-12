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
    fun `search and see-all transactions open the transactions tab`() {
        navigator.openFromHome(HomeDestination.Search)
        assertEquals(TopLevelDestination.Transactions, navigator.currentTab)

        navigator.selectTab(TopLevelDestination.Home)
        navigator.openFromHome(HomeDestination.Transactions)
        assertEquals(TopLevelDestination.Transactions, navigator.currentTab)
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
            HomeDestination.TransactionDetail("t1"),
            HomeDestination.AddTransaction,
        )

        unbuilt.forEach(navigator::openFromHome)

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }
}
