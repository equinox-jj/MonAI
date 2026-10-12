package com.djtech.monai.feature.auth.presentation.common

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue

/** The message under [field], or null when the field is fine. A field shows only its first issue. */
internal fun List<AuthFieldError>.fieldMessage(field: AuthField): UiText? =
    firstOrNull { it.field == field }?.issue?.toUiText(field)

internal fun FieldIssue.toUiText(field: AuthField): UiText = when (this) {
    FieldIssue.Required -> UiText.Resource(
        when (field) {
            AuthField.NAME -> R.string.auth_field_name_required
            AuthField.EMAIL -> R.string.auth_field_email_required
            AuthField.PASSWORD,
            AuthField.CURRENT_PASSWORD,
            AuthField.NEW_PASSWORD,
                -> R.string.auth_field_password_required
        },
    )

    is FieldIssue.TooShort -> UiText.Resource(R.string.auth_field_too_short, min)
    is FieldIssue.TooLong -> UiText.Resource(R.string.auth_field_too_long, max)
    FieldIssue.InvalidFormat -> UiText.Resource(R.string.auth_field_email_invalid)
    FieldIssue.SameAsCurrent -> UiText.Resource(R.string.auth_field_same_as_current)
    FieldIssue.Invalid -> UiText.Resource(R.string.auth_field_invalid)
}

/**
 * The banner for errors that belong to the whole form. Field-level errors ([AuthError.InvalidFields],
 * [AuthError.EmailAlreadyRegistered]) are shown on their fields; if one reaches here it falls back to the
 * generic message.
 */
internal fun AuthError.toFormErrorText(): UiText = when (this) {
    is AuthError.RateLimited -> retryAfter?.let {
        // Whole minutes, rounded up so the user never retries too early.
        val minutes = it.inWholeSeconds.plus(59).div(60).coerceAtLeast(1).toInt()
        UiText.Plural(R.plurals.auth_error_rate_limited_wait, minutes, minutes)
    } ?: UiText.Resource(R.string.auth_error_rate_limited)

    AuthError.InvalidCredentials -> UiText.Resource(R.string.auth_error_invalid_credentials)
    AuthError.Network -> UiText.Resource(R.string.auth_error_network)
    AuthError.EmailAlreadyRegistered,
    AuthError.WrongCurrentPassword,
    is AuthError.InvalidFields,
    AuthError.Unexpected,
        -> UiText.Resource(R.string.auth_error_unexpected)
}
