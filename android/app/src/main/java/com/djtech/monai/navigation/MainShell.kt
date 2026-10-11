package com.djtech.monai.navigation

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomBar
import com.djtech.monai.core.designsystem.component.MonAINavigationDrawer
import com.djtech.monai.core.designsystem.component.MonAINavigationRail
import com.djtech.monai.core.designsystem.component.monAIMainNavItems

private enum class NavLayout { BottomBar, Rail, Drawer }

/** Material window-size breakpoints: phone, tablet portrait (rail), tablet landscape (drawer). */
private fun navLayoutFor(width: Dp): NavLayout = when {
    width >= 840.dp -> NavLayout.Drawer
    width >= 600.dp -> NavLayout.Rail
    else -> NavLayout.BottomBar
}

/** The signed-in app: tab navigation around the current destination. */
@Composable
internal fun MainShell(modifier: Modifier = Modifier) {
    val navigator = rememberMainNavigator()
    val windowWidth =
        with(LocalDensity.current) { LocalWindowInfo.current.containerSize.width.toDp() }
    val items = monAIMainNavItems(
        home = stringResource(R.string.nav_home),
        transactions = stringResource(R.string.nav_transactions),
        wallets = stringResource(R.string.nav_wallets),
        settings = stringResource(R.string.nav_settings),
    )
    val selectedIndex = navigator.currentTab.ordinal
    val onItemClick =
        remember(navigator) { { index: Int -> navigator.selectTab(TopLevelDestination.entries[index]) } }
    // Quick add is not built yet.
    val onAddClick = {}
    val addLabel = stringResource(R.string.nav_add_transaction)
    val content = @Composable { modifier: Modifier -> MainNavDisplay(navigator, modifier) }

    when (navLayoutFor(windowWidth)) {
        NavLayout.BottomBar -> Column(modifier.fillMaxSize()) {
            content(Modifier.weight(1f))
            MonAIBottomBar(items, selectedIndex, onItemClick, onAddClick, addLabel)
        }

        NavLayout.Rail -> Row(modifier.fillMaxSize()) {
            MonAINavigationRail(items, selectedIndex, onItemClick, onAddClick, addLabel)
            content(Modifier.weight(1f))
        }

        NavLayout.Drawer -> Row(modifier.fillMaxSize()) {
            MonAINavigationDrawer(
                stringResource(R.string.app_name),
                items,
                selectedIndex,
                onItemClick,
                onAddClick,
                addLabel
            )
            content(Modifier.weight(1f))
        }
    }
}

@Composable
private fun MainNavDisplay(navigator: MainNavigator, modifier: Modifier = Modifier) {
    Box(modifier) {
        NavDisplay(
            backStack = navigator.backStack,
            onBack = navigator::goBack,
            entryProvider = entryProvider {
                entry<HomeRoute> { PlaceholderScreen(stringResource(R.string.nav_home)) }
                entry<TransactionsRoute> { PlaceholderScreen(stringResource(R.string.nav_transactions)) }
                entry<WalletsRoute> { PlaceholderScreen(stringResource(R.string.nav_wallets)) }
                entry<SettingsRoute> { PlaceholderScreen(stringResource(R.string.nav_settings)) }
            },
        )
    }
}
