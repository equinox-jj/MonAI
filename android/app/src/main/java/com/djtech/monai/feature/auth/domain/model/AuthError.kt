package com.djtech.monai.feature.auth.domain.model

/** Why an auth action failed, in terms the auth screens can show. */
sealed interface AuthError {
    /** Wrong email or password; the API does not say which. */
    data object InvalidCredentials : AuthError

    data object EmailAlreadyRegistered : AuthError

    /** The current password given to change the password is wrong. */
    data object WrongCurrentPassword : AuthError

    /** The server rejected one or more form fields. */
    data class InvalidFields(val errors: List<AuthFieldError>) : AuthError

    data object RateLimited : AuthError

    data object Network : AuthError

    data object Unexpected : AuthError
}

/** [code] is the API's field error code (`required`, `min_length`, `invalid_format`, …). */
data class AuthFieldError(
    val field: AuthField,
    val code: String,
    val params: Map<String, String> = emptyMap(),
)

enum class AuthField { NAME, EMAIL, PASSWORD, CURRENT_PASSWORD, NEW_PASSWORD }
