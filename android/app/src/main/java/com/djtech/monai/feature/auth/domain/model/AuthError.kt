package com.djtech.monai.feature.auth.domain.model

/** Why an auth action failed, in terms the auth screens can show. */
sealed interface AuthError {
    /** Wrong email or password; the API does not say which. */
    data object InvalidCredentials : AuthError

    data object EmailAlreadyRegistered : AuthError

    /** The current password given to change the password is wrong. */
    data object WrongCurrentPassword : AuthError

    /** The device or the server rejected one or more form fields. */
    data class InvalidFields(val errors: List<AuthFieldError>) : AuthError

    data object RateLimited : AuthError

    data object Network : AuthError

    data object Unexpected : AuthError
}

data class AuthFieldError(
    val field: AuthField,
    val issue: FieldIssue,
)

enum class AuthField { NAME, EMAIL, PASSWORD, CURRENT_PASSWORD, NEW_PASSWORD }

/** What is wrong with a field, decoded from the API's field error code and params. */
sealed interface FieldIssue {
    data object Required : FieldIssue

    data class TooShort(val min: Int) : FieldIssue

    data class TooLong(val max: Int) : FieldIssue

    data object InvalidFormat : FieldIssue

    /** The new password is the same as the current one. */
    data object SameAsCurrent : FieldIssue

    /** A code this app does not know yet; show a generic message. */
    data object Invalid : FieldIssue
}
