package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import org.junit.Assert.assertEquals
import org.junit.Test

class MainNavigatorTest {

    private val navigator = MainNavigator(
        stacks = TopLevelDestination.entries.associateWith { NavBackStack<NavKey>(it.route) },
        currentTab = mutableStateOf(TopLevelDestination.Home),
    )

    @Test
    fun `starts on home`() {
        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }

    @Test
    fun `another tab is shown above home`() {
        navigator.selectTab(TopLevelDestination.Wallets)

        assertEquals(TopLevelDestination.Wallets, navigator.currentTab)
        assertEquals(listOf(HomeRoute, WalletsRoute), navigator.backStack)
    }

    @Test
    fun `navigate pushes onto the current tab`() {
        navigator.selectTab(TopLevelDestination.Transactions)

        navigator.navigate(Detail)

        assertEquals(listOf(HomeRoute, TransactionsRoute, Detail), navigator.backStack)
    }

    @Test
    fun `back pops inside the tab first`() {
        navigator.selectTab(TopLevelDestination.Transactions)
        navigator.navigate(Detail)

        navigator.goBack()

        assertEquals(TopLevelDestination.Transactions, navigator.currentTab)
        assertEquals(listOf(HomeRoute, TransactionsRoute), navigator.backStack)
    }

    @Test
    fun `back from a tab root returns to home`() {
        navigator.selectTab(TopLevelDestination.Settings)

        navigator.goBack()

        assertEquals(TopLevelDestination.Home, navigator.currentTab)
        assertEquals(listOf(HomeRoute), navigator.backStack)
    }

    @Test
    fun `back on home pops home's own stack`() {
        navigator.navigate(Detail)

        navigator.goBack()

        assertEquals(listOf(HomeRoute), navigator.backStack)
    }

    @Test
    fun `switching tabs keeps each tab's stack`() {
        navigator.selectTab(TopLevelDestination.Transactions)
        navigator.navigate(Detail)

        navigator.selectTab(TopLevelDestination.Wallets)
        navigator.selectTab(TopLevelDestination.Transactions)

        assertEquals(listOf(HomeRoute, TransactionsRoute, Detail), navigator.backStack)
    }

    @Test
    fun `reselecting the current tab pops it to its root`() {
        navigator.selectTab(TopLevelDestination.Transactions)
        navigator.navigate(Detail)
        navigator.navigate(Detail2)

        navigator.selectTab(TopLevelDestination.Transactions)

        assertEquals(listOf(HomeRoute, TransactionsRoute), navigator.backStack)
    }

    @Test
    fun `only home is visible on home`() {
        assertEquals(listOf(TopLevelDestination.Home), navigator.visibleTabs)
    }

    @Test
    fun `another tab is visible above home`() {
        navigator.selectTab(TopLevelDestination.Wallets)

        assertEquals(listOf(TopLevelDestination.Home, TopLevelDestination.Wallets), navigator.visibleTabs)
    }

    @Test
    fun `stackOf returns each tab's own stack`() {
        navigator.selectTab(TopLevelDestination.Transactions)
        navigator.navigate(Detail)

        navigator.selectTab(TopLevelDestination.Wallets)

        assertEquals(listOf(TransactionsRoute, Detail), navigator.stackOf(TopLevelDestination.Transactions))
        assertEquals(listOf(WalletsRoute), navigator.stackOf(TopLevelDestination.Wallets))
    }

    private data object Detail : NavKey
    private data object Detail2 : NavKey

    @Test
    fun `popWhile pops matching entries but never the tab root`() {
        navigator.selectTab(TopLevelDestination.Transactions)
        navigator.navigate(Detail)

        navigator.popWhile { true }

        assertEquals(listOf(HomeRoute, TransactionsRoute), navigator.backStack)
    }
}
