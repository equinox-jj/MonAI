package com.djtech.monai.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.Stable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.rememberNavBackStack

/**
 * Navigation inside the signed-in app: one back stack per tab, so switching tabs
 * keeps where the user was. Back walks the current tab, then returns to Home.
 */
@Stable
class MainNavigator(
    private val stacks: Map<TopLevelDestination, NavBackStack<NavKey>>,
    currentTab: MutableState<TopLevelDestination>,
) {
    private var currentTabState by currentTab

    val currentTab: TopLevelDestination get() = currentTabState

    /** The tabs on screen, bottom first: Home under the current tab, so back from a tab root lands on Home. */
    val visibleTabs: List<TopLevelDestination>
        get() = if (currentTabState == TopLevelDestination.Home) {
            listOf(TopLevelDestination.Home)
        } else {
            listOf(TopLevelDestination.Home, currentTabState)
        }

    /** What is on screen: the [visibleTabs]' stacks, concatenated. */
    val backStack: List<NavKey>
        get() = visibleTabs.flatMap { stack(it) }

    /** [tab]'s own stack, shown or not. */
    fun stackOf(tab: TopLevelDestination): List<NavKey> = stack(tab)

    /** Selecting the tab already shown pops it to its root. */
    fun selectTab(tab: TopLevelDestination) {
        if (tab == currentTabState) {
            val stack = stack(tab)
            while (stack.size > 1) stack.removeAt(stack.lastIndex)
        } else {
            currentTabState = tab
        }
    }

    fun navigate(key: NavKey) {
        stack(currentTabState).add(key)
    }

    /** Pops the current tab's top entries while [predicate] holds, never its root. */
    fun popWhile(predicate: (NavKey) -> Boolean) {
        val stack = stack(currentTabState)
        while (stack.size > 1 && predicate(stack.last())) stack.removeAt(stack.lastIndex)
    }

    fun goBack() {
        val stack = stack(currentTabState)
        when {
            stack.size > 1 -> stack.removeAt(stack.lastIndex)
            currentTabState != TopLevelDestination.Home -> currentTabState =
                TopLevelDestination.Home
        }
    }

    private fun stack(tab: TopLevelDestination): NavBackStack<NavKey> = stacks.getValue(tab)
}

@Composable
fun rememberMainNavigator(): MainNavigator {
    // entries never change order, so calling remember in this loop is stable.
    val stacks = TopLevelDestination.entries.associateWith { rememberNavBackStack(it.route) }
    val currentTab = rememberSaveable { mutableStateOf(TopLevelDestination.Home) }
    return remember(stacks, currentTab) { MainNavigator(stacks, currentTab) }
}
