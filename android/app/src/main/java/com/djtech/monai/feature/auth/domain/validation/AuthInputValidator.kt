package com.djtech.monai.feature.auth.domain.validation

import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError

/**
 * Checks auth forms on the device with the backend's rules, field codes and params
 * (`backend/internal/auth/dto.go`), so a form shows the same errors offline as the server
 * would send. The server stays the authority; this only saves a round trip.
 *
 * Name and email are checked trimmed, as the repository sends them; passwords as typed.
 * Lengths count code points, as the backend's validator counts runes.
 */
object AuthInputValidator {

    fun register(name: String, email: String, password: String): List<AuthFieldError> = buildList {
        name.trim().let {
            when {
                it.isEmpty() -> add(AuthFieldError(AuthField.NAME, REQUIRED))
                it.length() > NAME_MAX -> add(maxLength(AuthField.NAME, NAME_MAX))
            }
        }
        email.trim().let {
            when {
                it.isEmpty() -> add(AuthFieldError(AuthField.EMAIL, REQUIRED))
                it.length() > EMAIL_MAX -> add(maxLength(AuthField.EMAIL, EMAIL_MAX))
                !EMAIL.matches(it) -> add(AuthFieldError(AuthField.EMAIL, INVALID_FORMAT))
            }
        }
        newPasswordError(AuthField.PASSWORD, password)?.let(::add)
    }

    // Login only checks presence and shape; length rules would hint at what a password may be.
    fun login(email: String, password: String): List<AuthFieldError> = buildList {
        email.trim().let {
            when {
                it.isEmpty() -> add(AuthFieldError(AuthField.EMAIL, REQUIRED))
                !EMAIL.matches(it) -> add(AuthFieldError(AuthField.EMAIL, INVALID_FORMAT))
            }
        }
        if (password.isEmpty()) add(AuthFieldError(AuthField.PASSWORD, REQUIRED))
    }

    fun changePassword(currentPassword: String, newPassword: String): List<AuthFieldError> = buildList {
        if (currentPassword.isEmpty()) add(AuthFieldError(AuthField.CURRENT_PASSWORD, REQUIRED))
        val newError = newPasswordError(AuthField.NEW_PASSWORD, newPassword)
            ?: AuthFieldError(AuthField.NEW_PASSWORD, NOT_EQUAL, mapOf("other" to "current_password"))
                .takeIf { newPassword == currentPassword }
        newError?.let(::add)
    }

    private fun newPasswordError(field: AuthField, password: String): AuthFieldError? = when {
        password.isEmpty() -> AuthFieldError(field, REQUIRED)
        password.length() < PASSWORD_MIN -> AuthFieldError(field, MIN_LENGTH, mapOf("min" to "$PASSWORD_MIN"))
        password.length() > PASSWORD_MAX -> maxLength(field, PASSWORD_MAX)
        else -> null
    }

    private fun maxLength(field: AuthField, max: Int) = AuthFieldError(field, MAX_LENGTH, mapOf("max" to "$max"))

    private fun String.length(): Int = codePointCount(0, length)

    private const val NAME_MAX = 100
    private const val EMAIL_MAX = 254
    private const val PASSWORD_MIN = 8
    private const val PASSWORD_MAX = 72

    private const val REQUIRED = "required"
    private const val MIN_LENGTH = "min_length"
    private const val MAX_LENGTH = "max_length"
    private const val INVALID_FORMAT = "invalid_format"
    private const val NOT_EQUAL = "not_equal"

    // Loose on purpose: catches typos without rejecting addresses the server accepts.
    private val EMAIL = Regex("""[^\s@]+@[^\s@]+\.[^\s@]+""")
}
