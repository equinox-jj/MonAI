package com.djtech.monai.navigation

import androidx.compose.material3.Text
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation3.runtime.NavEntry
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.ui.NavDisplay
import kotlinx.serialization.Serializable
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

class MainNavEntriesTest {

    @get:Rule
    val compose = createComposeRule()

    private lateinit var navigator: MainNavigator
    private val created = mutableListOf<NavKey>()
    private val cleared = mutableListOf<NavKey>()

    /** Stands in for a screen's ViewModel, whose init would hit the API. */
    private inner class ScreenViewModel(private val key: NavKey) : ViewModel() {
        init {
            created += key
        }

        override fun onCleared() {
            cleared += key
        }
    }

    private fun setContent() {
        compose.setContent {
            navigator = rememberMainNavigator()
            val entries = rememberMainNavEntries(navigator) { key ->
                NavEntry(key) {
                    viewModel { ScreenViewModel(key) }
                    Text(key.toString())
                }
            }
            NavDisplay(entries = entries, onBack = navigator::goBack)
        }
        compose.waitForIdle()
    }

    private fun act(action: MainNavigator.() -> Unit) {
        compose.runOnIdle { navigator.action() }
        compose.waitForIdle()
    }

    @Test
    fun switchingAwayFromATabAndBackKeepsItsViewModel() {
        setContent()

        act { selectTab(TopLevelDestination.Transactions) }
        act { selectTab(TopLevelDestination.Wallets) }
        act { selectTab(TopLevelDestination.Transactions) }

        assertEquals(listOf(HomeRoute, TransactionsRoute, WalletsRoute), created)
        assertEquals(emptyList<NavKey>(), cleared)
    }

    @Test
    fun goingBackToHomeKeepsTheTabsViewModel() {
        setContent()

        act { selectTab(TopLevelDestination.Wallets) }
        act { goBack() }
        act { selectTab(TopLevelDestination.Wallets) }

        assertEquals(listOf(HomeRoute, WalletsRoute), created)
        assertEquals(emptyList<NavKey>(), cleared)
    }

    @Test
    fun poppingAnEntryClearsItsViewModel() {
        setContent()

        act { selectTab(TopLevelDestination.Transactions) }
        act { navigate(TestDetail) }
        act { goBack() }

        assertEquals(listOf(TestDetail), cleared)
    }

    @Serializable
    private data object TestDetail : NavKey
}
