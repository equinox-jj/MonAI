package com.djtech.monai.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.navigation3.rememberViewModelStoreNavEntryDecorator
import androidx.navigation3.runtime.NavEntry
import androidx.navigation3.runtime.NavEntryDecorator
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.rememberDecoratedNavEntries
import androidx.navigation3.runtime.rememberSaveableStateHolderNavEntryDecorator

/**
 * The entries NavDisplay renders: the [MainNavigator.visibleTabs]' stacks, concatenated.
 *
 * Each tab's stack is decorated on its own and every tab is decorated on every composition, so an
 * entry's ViewModel and saved state (scroll, paging cache) only go when it is popped from its tab.
 * Decorating the shown back stack as a whole would clear a tab's entries each time the user
 * switched away from it, refetching everything on the way back.
 */
@Composable
internal fun rememberMainNavEntries(
    navigator: MainNavigator,
    entryProvider: (NavKey) -> NavEntry<NavKey>,
): List<NavEntry<NavKey>> {
    // entries never change order, so the remembers in this loop are stable.
    val entriesByTab = TopLevelDestination.entries.associateWith { tab ->
        val decorators = listOf<NavEntryDecorator<NavKey>>(
            rememberSaveableStateHolderNavEntryDecorator(),
            rememberViewModelStoreNavEntryDecorator(),
        )
        rememberDecoratedNavEntries(navigator.stackOf(tab), decorators, entryProvider)
    }
    return navigator.visibleTabs.flatMap { entriesByTab.getValue(it) }
}
