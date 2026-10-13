package com.djtech.monai.feature.wallets.presentation.walletform.model

sealed interface WalletFormMode {
    data object Add : WalletFormMode

    data class Edit(val id: String) : WalletFormMode
}

/** The current balance before and after a change to the starting balance, in rupiah. */
data class BalanceShift(val from: Long, val to: Long) {
    val delta: Long get() = to - from
}

sealed interface WalletFormDialog {
    /** Closing with unsaved changes. */
    data object Discard : WalletFormDialog

    data object ConfirmDelete : WalletFormDialog

    /** Delete was refused because the wallet has transactions. */
    data object ArchiveInstead : WalletFormDialog
}
