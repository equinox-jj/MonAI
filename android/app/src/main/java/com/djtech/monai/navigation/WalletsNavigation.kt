package com.djtech.monai.navigation

import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.wallets.presentation.archivedwallets.ArchivedWalletsRoute
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailDestination
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailRoute
import com.djtech.monai.feature.wallets.presentation.walletform.WalletFormRoute
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsDestination
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsRoute

/** Where the Wallets list's links lead. */
internal fun MainNavigator.openFromWallets(destination: WalletsDestination) {
    navigate(
        when (destination) {
            is WalletsDestination.Detail -> WalletDetailRoute(destination.id)
            WalletsDestination.Add -> WalletFormRoute()
            WalletsDestination.Archived -> ArchivedWalletsRoute
        },
    )
}

/** Where a wallet's detail leads; Transfer opens the transaction form as a transfer out of it. */
internal fun MainNavigator.openFromWalletDetail(destination: WalletDetailDestination) {
    navigate(
        when (destination) {
            is WalletDetailDestination.Edit -> WalletFormRoute(destination.walletId)
            is WalletDetailDestination.Transfer -> TransactionFormRoute(
                presetType = TransactionType.TRANSFER,
                presetWalletId = destination.walletId,
            )

            is WalletDetailDestination.Transaction -> TransactionDetailRoute(destination.id)
        },
    )
}

/** After a delete: closes the wallet's edit form and detail. */
internal fun MainNavigator.closeDeletedWallet(id: String) {
    popWhile { it.showsWallet(id) }
}

private fun NavKey.showsWallet(id: String): Boolean =
    (this is WalletFormRoute && this.id == id) || (this is WalletDetailRoute && this.id == id)

/** The Wallets tab, a wallet's detail and form, and the archived wallets. */
internal fun EntryProviderScope<NavKey>.walletsEntries(navigator: MainNavigator, config: MainNavConfig) {
    entry<WalletsRoute>(metadata = config.tabRootMetadata) {
        WalletsRoute(
            onNavigate = navigator::openFromWallets,
            detailPane = { id, paneModifier ->
                // Deleting from the pane needs no navigation: the list shows the next wallet.
                WalletDetailRoute(
                    walletId = id,
                    onNavigate = navigator::openFromWalletDetail,
                    onBack = {},
                    onDeleted = {},
                    modifier = paneModifier,
                    placement = ScreenPlacement.Pane,
                )
            },
        )
    }
    entry<WalletDetailRoute> { key ->
        WalletDetailRoute(
            walletId = key.id,
            onNavigate = navigator::openFromWalletDetail,
            onBack = navigator::goBack,
            onDeleted = navigator::closeDeletedWallet,
        )
    }
    formEntry<WalletFormRoute>(config) { key, modifier, placement ->
        WalletFormRoute(
            walletId = key.id,
            onClose = navigator::goBack,
            onDeleted = navigator::closeDeletedWallet,
            modifier = modifier,
            placement = placement,
        )
    }
    entry<ArchivedWalletsRoute> {
        ArchivedWalletsRoute(
            onBack = navigator::goBack,
            onOpenWallet = { id -> navigator.navigate(WalletDetailRoute(id)) },
        )
    }
}
