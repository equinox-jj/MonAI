package com.djtech.monai.feature.quickadd.domain.model

/** Why the AI couldn't read a phrase. Quick add then falls back to the phone's own reading. */
sealed interface QuickAddError {
    data object Network : QuickAddError

    /** The per-user AI quota is used up for now. */
    data object RateLimited : QuickAddError

    /** The AI model is down or didn't answer in time. */
    data object AiUnavailable : QuickAddError

    data object Unexpected : QuickAddError
}
