package com.djtech.monai.navigation

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.scene.DialogSceneStrategy
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomBar
import com.djtech.monai.core.designsystem.component.MonAINavigationDrawer
import com.djtech.monai.core.designsystem.component.MonAINavigationRail
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.component.monAIMainNavItems
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.undodelete.UndoDeleteRoute

/**
 * The signed-in app: tab navigation around the current destination. Phones get a bottom bar,
 * tablet portrait a rail and tablet landscape a drawer.
 */
@Composable
internal fun MainShell(modifier: Modifier = Modifier) {
    val navigator = rememberMainNavigator()
    val widthClass = currentWidthClass()
    val items = monAIMainNavItems(
        home = stringResource(R.string.nav_home),
        transactions = stringResource(R.string.nav_transactions),
        wallets = stringResource(R.string.nav_wallets),
        settings = stringResource(R.string.nav_settings),
    )
    val selectedIndex = navigator.currentTab.ordinal
    val onItemClick =
        remember(navigator) { { index: Int -> navigator.selectTab(TopLevelDestination.entries[index]) } }
    val onAddClick = remember(navigator) { { navigator.navigate(TransactionFormRoute()) } }
    val addLabel = stringResource(R.string.nav_add_transaction)
    val content = @Composable { modifier: Modifier -> MainNavDisplay(navigator, widthClass, modifier) }
    // Without a bottom bar to sit on, the content keeps clear of the system navigation bar itself.
    val railContentModifier = Modifier
        .background(MonAITheme.colors.background)
        .windowInsetsPadding(
            WindowInsets.navigationBars.only(WindowInsetsSides.Bottom + WindowInsetsSides.End),
        )

    when (widthClass) {
        MonAIWidthClass.Compact -> Column(modifier.fillMaxSize()) {
            content(Modifier.weight(1f))
            // Detail, form and search take the whole phone screen.
            if (!navigator.backStack.last().isFullScreen()) {
                MonAIBottomBar(
                    items,
                    selectedIndex,
                    onItemClick,
                    onAddClick,
                    addLabel,
                )
            }
        }

        MonAIWidthClass.Medium -> Row(modifier.fillMaxSize()) {
            MonAINavigationRail(
                items,
                selectedIndex,
                onItemClick,
                onAddClick,
                addLabel,
            )
            content(
                Modifier
                    .weight(1f)
                    .then(railContentModifier),
            )
        }

        MonAIWidthClass.Expanded -> Row(modifier.fillMaxSize()) {
            MonAINavigationDrawer(
                stringResource(R.string.app_name),
                items,
                selectedIndex,
                onItemClick,
                onAddClick,
                addLabel,
            )
            content(
                Modifier
                    .weight(1f)
                    .then(railContentModifier),
            )
        }
    }
}

@Composable
private fun MainNavDisplay(
    navigator: MainNavigator,
    widthClass: MonAIWidthClass,
    modifier: Modifier = Modifier,
) {
    val config = remember(widthClass) { MainNavConfig(isExpanded = widthClass == MonAIWidthClass.Expanded) }
    Box(modifier) {
        // Each tab keeps its entries' ViewModels while another tab is shown, so switching tabs doesn't refetch.
        val entries = rememberMainNavEntries(
            navigator,
            entryProvider {
                homeEntries(navigator)
                transactionsEntries(navigator, config)
                quickAddEntries(navigator, config)
                receiptEntries(navigator)
                walletsEntries(navigator, config)
                settingsEntries(navigator, config)
            },
        )
        NavDisplay(
            entries = entries,
            sceneStrategies = listOf(DialogSceneStrategy()),
            onBack = navigator::goBack,
        )
        UndoDeleteRoute(Modifier.align(Alignment.BottomCenter))
    }
}
