package com.djtech.monai.feature.transactions.presentation.common.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionLoadException

/** A snackbar message for a failed action. Field errors are shown on the form instead. */
fun TransactionError.toMessage(): UiText = UiText.Resource(
    when (this) {
        TransactionError.Network -> R.string.transaction_error_network
        TransactionError.NotFound -> R.string.transaction_error_not_found
        TransactionError.WalletArchived -> R.string.transaction_error_wallet_archived
        is TransactionError.InvalidFields, TransactionError.Unexpected -> R.string.transaction_error_unexpected
    },
)

/** Whether a paged list failed because the device is offline. */
fun Throwable.isOffline(): Boolean = (this as? TransactionLoadException)?.error == TransactionError.Network
