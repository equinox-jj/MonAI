package com.djtech.monai.navigation

import com.djtech.monai.feature.home.presentation.home.HomeDestination

/**
 * Where Home's links lead. "See all" and the avatar switch tabs, search and transactions open on
 * top of Home; the rest wait for their screens and do nothing until then.
 */
internal fun MainNavigator.openFromHome(destination: HomeDestination) {
    when (destination) {
        HomeDestination.Transactions -> selectTab(TopLevelDestination.Transactions)
        HomeDestination.Search -> navigate(TransactionSearchRoute())
        is HomeDestination.TransactionDetail -> navigate(TransactionDetailRoute(destination.transactionId))
        HomeDestination.AddTransaction -> navigate(TransactionFormRoute())

        HomeDestination.Wallets -> selectTab(TopLevelDestination.Wallets)
        HomeDestination.Settings -> selectTab(TopLevelDestination.Settings)

        HomeDestination.QuickAdd,
        HomeDestination.ScanReceipt,
        is HomeDestination.WalletDetail,
        HomeDestination.AddWallet,
        HomeDestination.Budget,
        HomeDestination.Report,
            -> Unit
    }
}
