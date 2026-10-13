package com.djtech.monai.feature.quickadd.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.quickadd.domain.model.QuickAddError

// Branches on the backend's stable error codes, never on the message.
fun ApiError.toQuickAddError(): QuickAddError = when (this) {
    ApiError.Network -> QuickAddError.Network
    is ApiError.Unknown -> QuickAddError.Unexpected
    is ApiError.Http -> when (code) {
        "rate_limited" -> QuickAddError.RateLimited
        "ai_unavailable" -> QuickAddError.AiUnavailable
        else -> QuickAddError.Unexpected
    }
}
