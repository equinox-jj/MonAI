package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailDestination
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsDestination
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class WalletsNavigationTest {

    private val navigator = MainNavigator(
        stacks = TopLevelDestination.entries.associateWith { NavBackStack<NavKey>(it.route) },
        currentTab = mutableStateOf(TopLevelDestination.Wallets),
    )

    @Test
    fun `the list's links open on the wallets tab`() {
        navigator.openFromWallets(WalletsDestination.Detail("bca"))
        navigator.openFromWallets(WalletsDestination.Add)
        navigator.openFromWallets(WalletsDestination.Archived)

        assertEquals(
            listOf(HomeRoute, WalletsRoute, WalletDetailRoute("bca"), WalletFormRoute(), ArchivedWalletsRoute),
            navigator.backStack,
        )
    }

    @Test
    fun `the detail's edit, transfer and transaction links`() {
        navigator.openFromWalletDetail(WalletDetailDestination.Edit("bca"))
        navigator.openFromWalletDetail(WalletDetailDestination.Transfer("bca"))
        navigator.openFromWalletDetail(WalletDetailDestination.Transaction("t1"))

        assertEquals(
            listOf(
                HomeRoute,
                WalletsRoute,
                WalletFormRoute("bca"),
                TransactionFormRoute(presetType = TransactionType.TRANSFER, presetWalletId = "bca"),
                TransactionDetailRoute("t1"),
            ),
            navigator.backStack,
        )
    }

    @Test
    fun `deleting a wallet closes its form and detail, not other screens`() {
        navigator.navigate(ArchivedWalletsRoute)
        navigator.navigate(WalletDetailRoute("bca"))
        navigator.navigate(WalletFormRoute("bca"))

        navigator.closeDeletedWallet("bca")

        assertEquals(listOf(HomeRoute, WalletsRoute, ArchivedWalletsRoute), navigator.backStack)
    }

    @Test
    fun `wallet detail, form and archive are full screen, the tab root is not`() {
        assertTrue(WalletDetailRoute("bca").isFullScreen())
        assertTrue(WalletFormRoute().isFullScreen())
        assertTrue(ArchivedWalletsRoute.isFullScreen())
        assertFalse(WalletsRoute.isFullScreen())
    }
}
