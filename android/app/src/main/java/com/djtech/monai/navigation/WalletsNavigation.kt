package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailDestination
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsDestination

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
