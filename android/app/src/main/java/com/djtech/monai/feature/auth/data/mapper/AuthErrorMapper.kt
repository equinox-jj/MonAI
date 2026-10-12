package com.djtech.monai.feature.auth.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError

// Branches on the backend's stable error codes, never on the message.
fun ApiError.toAuthError(): AuthError = when (this) {
    ApiError.Network -> AuthError.Network
    is ApiError.Unknown -> AuthError.Unexpected
    is ApiError.Http -> when (code) {
        "invalid_credentials" -> AuthError.InvalidCredentials
        "conflict" -> AuthError.EmailAlreadyRegistered
        "invalid_password" -> AuthError.WrongCurrentPassword
        "rate_limited" -> AuthError.RateLimited
        "validation_failed" -> fields
            .mapNotNull { field ->
                API_FIELDS[field.field]?.let { AuthFieldError(it, field.code, field.params) }
            }
            .takeIf { it.isNotEmpty() }
            ?.let(AuthError::InvalidFields)
            ?: AuthError.Unexpected
        else -> AuthError.Unexpected
    }
}

private val API_FIELDS = mapOf(
    "name" to AuthField.NAME,
    "email" to AuthField.EMAIL,
    "password" to AuthField.PASSWORD,
    "current_password" to AuthField.CURRENT_PASSWORD,
    "new_password" to AuthField.NEW_PASSWORD,
)
