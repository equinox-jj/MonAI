package com.djtech.monai.navigation

import com.djtech.monai.feature.home.presentation.home.HomeDestination

/**
 * Where Home's links lead. Search, "See all" and the avatar switch tabs; the rest wait for
 * their screens and do nothing until then.
 */
internal fun MainNavigator.openFromHome(destination: HomeDestination) {
    when (destination) {
        HomeDestination.Search,
        HomeDestination.Transactions,
            -> selectTab(TopLevelDestination.Transactions)

        HomeDestination.Wallets -> selectTab(TopLevelDestination.Wallets)
        HomeDestination.Settings -> selectTab(TopLevelDestination.Settings)

        HomeDestination.QuickAdd,
        HomeDestination.ScanReceipt,
        is HomeDestination.WalletDetail,
        HomeDestination.AddWallet,
        HomeDestination.Budget,
        HomeDestination.Report,
        is HomeDestination.TransactionDetail,
        HomeDestination.AddTransaction,
            -> Unit
    }
}
