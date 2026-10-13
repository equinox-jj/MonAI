package com.djtech.monai.feature.transactions.domain.model

/**
 * Steps of work that uploads a receipt photo: progress while sending, then the outcome (the
 * receipt key for a bare upload, the transaction when it is created or attached).
 */
sealed interface ReceiptUpload<out T> {
    /** [fraction] of the photo sent, 0..1. */
    data class Progress(val fraction: Float) : ReceiptUpload<Nothing>

    data class Done<T>(val result: TransactionResult<T>) : ReceiptUpload<T>
}
