package com.djtech.monai.navigation

import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.search.SearchRoute
import com.djtech.monai.feature.transactions.presentation.transactiondetail.TransactionDetailRoute
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormRoute
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsDestination
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsRoute

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

/** The Transactions tab, a transaction's detail and form, and search. */
internal fun EntryProviderScope<NavKey>.transactionsEntries(navigator: MainNavigator, config: MainNavConfig) {
    val editTransaction = { id: String -> navigator.navigate(TransactionFormRoute(id)) }
    entry<TransactionsRoute>(metadata = config.tabRootMetadata) {
        TransactionsRoute(
            onNavigate = navigator::openFromTransactions,
            detailPane = { id, paneModifier ->
                TransactionDetailRoute(
                    transactionId = id,
                    onBack = {},
                    onEdit = editTransaction,
                    modifier = paneModifier,
                    placement = ScreenPlacement.Pane,
                )
            },
        )
    }
    entry<TransactionDetailRoute> { key ->
        TransactionDetailRoute(
            transactionId = key.id,
            onBack = navigator::goBack,
            onEdit = editTransaction,
        )
    }
    formEntry<TransactionFormRoute>(config) { key, modifier, placement ->
        TransactionFormRoute(
            transactionId = key.id,
            onClose = navigator::goBack,
            onDeleted = navigator::closeDeletedTransaction,
            onNewCategory = { type -> navigator.navigate(CategoryFormRoute(type)) },
            modifier = modifier,
            preset = TransactionFormPreset(
                type = key.presetType ?: TransactionType.EXPENSE,
                walletId = key.presetWalletId,
                draft = key.draft?.toModel(),
            ),
            onSaved = { if (key.draft != null) navigator.closeQuickAdd() else navigator.goBack() },
            // Scanning is offered only on a blank add form.
            onScan = if (key.id == null && key.draft == null) {
                { navigator.navigate(ScanReceiptRoute) }
            } else {
                null
            },
            placement = placement,
        )
    }
    entry<TransactionSearchRoute> { key ->
        SearchRoute(
            initialMonth = key.month,
            onBack = navigator::goBack,
            onOpenTransaction = { id -> navigator.navigate(TransactionDetailRoute(id)) },
        )
    }
}
