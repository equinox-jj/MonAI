package com.djtech.monai.feature.auth.domain.validation

import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue

/**
 * Checks auth forms on the device with the backend's rules (`backend/internal/auth/dto.go`),
 * so a form shows the same errors offline as the server would send. The server stays the
 * authority; this only saves a round trip, which on login also counts toward the rate limit.
 *
 * Name and email are checked trimmed, as the repository sends them; passwords as typed.
 * Lengths count code points, as the backend's validator counts runes, except the password
 * maximum (see [passwordIssue]).
 */
object AuthInputValidator {

    fun register(name: String, email: String, password: String): List<AuthFieldError> = buildList {
        addIssue(AuthField.NAME, nameIssue(name.trim()))
        addIssue(AuthField.EMAIL, emailIssue(email.trim(), max = EMAIL_MAX))
        addIssue(AuthField.PASSWORD, passwordIssue(password))
    }

    // The server applies the full password rules on login too, so checking them here hides nothing.
    fun login(email: String, password: String): List<AuthFieldError> = buildList {
        addIssue(AuthField.EMAIL, emailIssue(email.trim(), max = null))
        addIssue(AuthField.PASSWORD, passwordIssue(password))
    }

    fun changePassword(currentPassword: String, newPassword: String): List<AuthFieldError> = buildList {
        if (currentPassword.isEmpty()) add(AuthFieldError(AuthField.CURRENT_PASSWORD, FieldIssue.Required))
        addIssue(
            AuthField.NEW_PASSWORD,
            passwordIssue(newPassword) ?: FieldIssue.SameAsCurrent.takeIf { newPassword == currentPassword },
        )
    }

    private fun MutableList<AuthFieldError>.addIssue(field: AuthField, issue: FieldIssue?) {
        if (issue != null) add(AuthFieldError(field, issue))
    }

    private fun nameIssue(name: String): FieldIssue? = when {
        name.isEmpty() -> FieldIssue.Required
        name.codePointLength() > NAME_MAX -> FieldIssue.TooLong(NAME_MAX)
        else -> null
    }

    private fun emailIssue(email: String, max: Int?): FieldIssue? = when {
        email.isEmpty() -> FieldIssue.Required
        max != null && email.codePointLength() > max -> FieldIssue.TooLong(max)
        !EMAIL.matches(email) -> FieldIssue.InvalidFormat
        else -> null
    }

    private fun passwordIssue(password: String): FieldIssue? = when {
        password.isEmpty() -> FieldIssue.Required
        password.codePointLength() < PASSWORD_MIN -> FieldIssue.TooShort(PASSWORD_MIN)
        // bcrypt takes at most 72 bytes. The server's validator counts runes, so a longer
        // non-ASCII password would pass it and then fail hashing with a 500.
        password.encodeToByteArray().size > PASSWORD_MAX_BYTES -> FieldIssue.TooLong(PASSWORD_MAX_BYTES)
        else -> null
    }

    private fun String.codePointLength(): Int = codePointCount(0, length)

    private const val NAME_MAX = 100
    private const val EMAIL_MAX = 254
    private const val PASSWORD_MIN = 8
    private const val PASSWORD_MAX_BYTES = 72

    // Loose on purpose: catches typos without rejecting addresses the server accepts.
    private val EMAIL = Regex("""[^\s@]+@[^\s@]+\.[^\s@]+""")
}
