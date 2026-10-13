package com.djtech.monai.feature.wallets.presentation.common

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.wallets.domain.model.WalletError

/** A snackbar line for a failed wallet action. Field errors go on their fields instead; see the form. */
internal fun WalletError.message(): UiText = UiText.Resource(
    when (this) {
        WalletError.Network -> R.string.wallets_error_network
        WalletError.NotFound -> R.string.wallets_error_not_found
        WalletError.DefaultRequired -> R.string.wallets_error_default_required
        WalletError.HasTransactions -> R.string.wallets_error_has_transactions
        is WalletError.InvalidFields, WalletError.Unexpected -> R.string.wallets_error_unexpected
    },
)
