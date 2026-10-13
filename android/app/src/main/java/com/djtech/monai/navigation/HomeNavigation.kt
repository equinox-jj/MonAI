package com.djtech.monai.navigation

import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.feature.home.presentation.home.HomeDestination

/**
 * Where Home's links lead. "See all" and the avatar switch tabs; search, transactions, the budget
 * and the report open on top of Home. Quick add and scan wait for their screens and do nothing until then.
 */
internal fun MainNavigator.openFromHome(destination: HomeDestination) {
    when (destination) {
        HomeDestination.Transactions -> selectTab(TopLevelDestination.Transactions)
        HomeDestination.Search -> navigate(TransactionSearchRoute())
        is HomeDestination.TransactionDetail -> navigate(TransactionDetailRoute(destination.transactionId))
        HomeDestination.AddTransaction -> navigate(TransactionFormRoute())

        is HomeDestination.WalletDetail -> navigate(WalletDetailRoute(destination.walletId))
        HomeDestination.AddWallet -> navigate(WalletFormRoute())

        HomeDestination.Wallets -> selectTab(TopLevelDestination.Wallets)
        HomeDestination.Settings -> selectTab(TopLevelDestination.Settings)

        is HomeDestination.Budget -> navigate(BudgetRoute(destination.month.toApiString()))
        is HomeDestination.Report -> navigate(ReportRoute(destination.month.toApiString()))

        HomeDestination.QuickAdd,
        HomeDestination.ScanReceipt,
            -> Unit
    }
}
