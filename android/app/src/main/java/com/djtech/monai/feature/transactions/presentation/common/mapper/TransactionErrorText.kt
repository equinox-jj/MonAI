package com.djtech.monai.feature.transactions.presentation.common.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionLoadException

/** A snackbar message for a failed action. Field errors are shown on the form instead. */
fun TransactionError.toMessage(): UiText = when (this) {
    TransactionError.Network -> UiText.Resource(R.string.transaction_error_network)
    TransactionError.NotFound -> UiText.Resource(R.string.transaction_error_not_found)
    TransactionError.WalletArchived -> UiText.Resource(R.string.transaction_error_wallet_archived)
    TransactionError.PhotoTooLarge -> UiText.Resource(R.string.transaction_error_photo_too_large)
    TransactionError.PhotoUnsupported -> UiText.Resource(R.string.transaction_error_photo_unsupported)
    is TransactionError.RateLimited -> retryAfter?.inWholeMinutes?.takeIf { it > 0 }?.let {
        UiText.Plural(R.plurals.transaction_error_rate_limited, it.toInt(), it.toInt())
    } ?: UiText.Resource(R.string.transaction_error_rate_limited_soon)

    is TransactionError.InvalidFields,
    TransactionError.Unexpected,
        -> UiText.Resource(R.string.transaction_error_unexpected)
}

/** Why a transaction couldn't be loaded, for a screen that has nothing to show instead. */
fun TransactionError.loadMessage(): UiText = when (this) {
    TransactionError.Network -> UiText.Resource(R.string.transactions_load_failed_network)
    else -> toMessage()
}

/** Whether a paged list failed because the device is offline. */
fun Throwable.isOffline(): Boolean = (this as? TransactionLoadException)?.error == TransactionError.Network
