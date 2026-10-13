package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsDestination

/** Where the Transactions list's links lead. */
internal fun MainNavigator.openFromTransactions(destination: TransactionsDestination) {
    navigate(
        when (destination) {
            is TransactionsDestination.Search -> TransactionSearchRoute(destination.month.toApiString())
            TransactionsDestination.Add -> TransactionFormRoute()
            is TransactionsDestination.Detail -> TransactionDetailRoute(destination.id)
            is TransactionsDestination.Edit -> TransactionFormRoute(destination.id)
        },
    )
}

/** After a delete from the edit form: closes the form and the detail screen of that transaction. */
internal fun MainNavigator.closeDeletedTransaction(id: String) {
    popWhile { it.showsTransaction(id) }
}

private fun NavKey.showsTransaction(id: String): Boolean =
    (this is TransactionFormRoute && this.id == id) || (this is TransactionDetailRoute && this.id == id)
