package com.djtech.monai.feature.wallets.presentation.walletdetail

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.OutflowDay
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletDetailDialog
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletRowLookups
import java.time.LocalDate
import java.time.YearMonth

/**
 * The transaction rows are paged separately; see `WalletDetailViewModel.transactions`.
 *
 * @param month the month the chart and the transaction list cover: the current one.
 * @param wallet null until it is cached; then [isLoading] or [loadError] says why.
 * @param loadError the fetch failed with nothing cached, or the wallet no longer exists.
 * @param outflows one bar per day of [month] so far.
 * @param isWorking an action (default, archive, delete) is running; its buttons are disabled.
 */
@Immutable
data class WalletDetailState(
    val month: YearMonth,
    val today: LocalDate,
    val wallet: Wallet? = null,
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val outflows: List<OutflowDay> = emptyList(),
    /** Rupiah out of the wallet in [month]. */
    val outflowTotal: Long = 0,
    val lookups: WalletRowLookups = WalletRowLookups(),
    val isWorking: Boolean = false,
    val dialog: WalletDetailDialog? = null,
) {
    private val isActive: Boolean get() = wallet != null && !wallet.isArchived

    /** The default wallet can't be archived; the screen says why. */
    val canArchive: Boolean get() = isActive && wallet?.isDefault == false
    val canUnarchive: Boolean get() = wallet?.isArchived == true
    val canDelete: Boolean get() = wallet?.isDefault == false
    val canSetDefault: Boolean get() = isActive && wallet?.isDefault == false

    /** Archived wallets can't send or receive money. */
    val canTransfer: Boolean get() = isActive
}

sealed interface WalletDetailIntent {
    data object Back : WalletDetailIntent

    data object Edit : WalletDetailIntent

    /** Opens the transaction form as a transfer out of this wallet. */
    data object Transfer : WalletDetailIntent

    data class OpenTransaction(val id: String) : WalletDetailIntent

    data object SetDefault : WalletDetailIntent

    data object Archive : WalletDetailIntent

    data object Unarchive : WalletDetailIntent

    /** Asks to confirm first. */
    data object Delete : WalletDetailIntent

    data object ConfirmDelete : WalletDetailIntent

    /** Archives from the dialog shown when delete was refused. */
    data object ConfirmArchive : WalletDetailIntent

    data object DismissDialog : WalletDetailIntent

    data object Retry : WalletDetailIntent
}

sealed interface WalletDetailEffect {
    data object NavigateBack : WalletDetailEffect

    data class Navigate(val destination: WalletDetailDestination) : WalletDetailEffect

    /** The wallet is gone: close its screens. */
    data class Deleted(val id: String) : WalletDetailEffect

    data class ShowMessage(val message: UiText) : WalletDetailEffect
}

sealed interface WalletDetailDestination {
    data class Edit(val walletId: String) : WalletDetailDestination
    data class Transfer(val walletId: String) : WalletDetailDestination
    data class Transaction(val id: String) : WalletDetailDestination
}
