package com.djtech.monai.feature.receipt.domain.model

/** Why a receipt couldn't be read into a draft. The review still opens so the photo isn't lost. */
sealed interface ReceiptError {
    data object Network : ReceiptError

    /** The per-user AI quota is used up for now. */
    data object RateLimited : ReceiptError

    /** The AI model is down or didn't answer in time. */
    data object AiUnavailable : ReceiptError

    data object Unexpected : ReceiptError
}
