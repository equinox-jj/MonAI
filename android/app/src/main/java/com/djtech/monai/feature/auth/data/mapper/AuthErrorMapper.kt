package com.djtech.monai.feature.auth.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue

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
            .mapNotNull { field -> API_FIELDS[field.field]?.let { AuthFieldError(it, field.toFieldIssue()) } }
            .takeIf { it.isNotEmpty() }
            ?.let(AuthError::InvalidFields)
            ?: AuthError.Unexpected
        else -> AuthError.Unexpected
    }
}

// Unknown codes, or a length code missing its limit, still mark the field as invalid.
private fun FieldError.toFieldIssue(): FieldIssue = when (code) {
    "required" -> FieldIssue.Required
    "min_length" -> params["min"]?.toIntOrNull()?.let(FieldIssue::TooShort) ?: FieldIssue.Invalid
    "max_length" -> params["max"]?.toIntOrNull()?.let(FieldIssue::TooLong) ?: FieldIssue.Invalid
    "invalid_format" -> FieldIssue.InvalidFormat
    // Auth's only `nefield` rule: new_password must differ from current_password.
    "not_equal" -> FieldIssue.SameAsCurrent
    else -> FieldIssue.Invalid
}

private val API_FIELDS = mapOf(
    "name" to AuthField.NAME,
    "email" to AuthField.EMAIL,
    "password" to AuthField.PASSWORD,
    "current_password" to AuthField.CURRENT_PASSWORD,
    "new_password" to AuthField.NEW_PASSWORD,
)
