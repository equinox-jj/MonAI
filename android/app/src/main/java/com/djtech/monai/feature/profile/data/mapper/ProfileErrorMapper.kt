package com.djtech.monai.feature.profile.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileError

// Branches on the backend's stable error codes, never on the message.
fun ApiError.toProfileError(): ProfileError = when (this) {
    ApiError.Network -> ProfileError.Network
    is ApiError.Unknown -> ProfileError.Unexpected
    is ApiError.Http -> when (code) {
        "invalid_password" -> ProfileError.WrongPassword
        "last_admin" -> ProfileError.LastAdmin
        "rate_limited" -> ProfileError.RateLimited(retryAfter)
        "validation_failed" -> fields.firstNotNullOfOrNull(FieldError::toProfileError) ?: ProfileError.Unexpected
        else -> ProfileError.Unexpected
    }
}

private fun FieldError.toProfileError(): ProfileError? = when (field) {
    "name" -> ProfileError.InvalidName(
        when (code) {
            "required", "min_length" -> NameIssue.REQUIRED
            "max_length" -> NameIssue.TOO_LONG
            else -> NameIssue.INVALID
        },
    )
    "timezone" -> ProfileError.InvalidTimezone
    "file" -> if (code == "max_size") ProfileError.PhotoTooLarge else ProfileError.PhotoUnsupported
    "password" -> ProfileError.PasswordRequired
    else -> null
}
