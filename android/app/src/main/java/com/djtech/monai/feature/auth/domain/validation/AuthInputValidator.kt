package com.djtech.monai.feature.auth.domain.validation

import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator.passwordIssue

/**
 * Checks auth forms on the device with the backend's rules (`backend/internal/auth/dto.go`),
 * so a form shows the same errors offline as the server would send. The server stays the
 * authority; this only saves a round trip, which on login also counts toward the rate limit.
 *
 * Takes input already cleaned up by [normalizedName] and [normalizedEmail], as the use cases send it.
 * Lengths count code points, as the backend's validator counts runes, except the password
 * maximum (see [passwordIssue]).
 */
object AuthInputValidator {

    /** Minimum password length in code points; the register screen shows it in its hint. */
    const val PASSWORD_MIN = 8

    /** Whether [password] meets the minimum length; drives the register screen's live hint. */
    fun isPasswordLongEnough(password: String): Boolean = password.codePointLength() >= PASSWORD_MIN

    fun register(name: String, email: String, password: String): List<AuthFieldError> = buildList {
        addIssue(AuthField.NAME, nameIssue(name))
        addIssue(AuthField.EMAIL, emailIssue(email, max = EMAIL_MAX))
        addIssue(AuthField.PASSWORD, passwordIssue(password, min = PASSWORD_MIN))
    }

    // The server has no password minimum on login, so a short one fails as wrong credentials.
    fun login(email: String, password: String): List<AuthFieldError> = buildList {
        addIssue(AuthField.EMAIL, emailIssue(email, max = null))
        addIssue(AuthField.PASSWORD, passwordIssue(password, min = null))
    }

    fun changePassword(currentPassword: String, newPassword: String): List<AuthFieldError> =
        buildList {
            if (currentPassword.isEmpty()) add(AuthFieldError(AuthField.CURRENT_PASSWORD, FieldIssue.Required))
            addIssue(
                AuthField.NEW_PASSWORD,
                passwordIssue(newPassword, min = PASSWORD_MIN)
                    ?: FieldIssue.SameAsCurrent.takeIf { newPassword == currentPassword },
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

    private fun passwordIssue(password: String, min: Int?): FieldIssue? = when {
        password.isEmpty() -> FieldIssue.Required
        min != null && password.codePointLength() < min -> FieldIssue.TooShort(min)
        // bcrypt takes at most 72 bytes, so the server caps bytes (maxbytes), not characters.
        password.encodeToByteArray().size > PASSWORD_MAX_BYTES -> FieldIssue.TooLong(PASSWORD_MAX_BYTES)

        else -> null
    }

    private fun String.codePointLength(): Int = codePointCount(0, length)

    private const val NAME_MAX = 100
    private const val EMAIL_MAX = 254
    private const val PASSWORD_MAX_BYTES = 72

    // Loose on purpose: catches typos without rejecting addresses the server accepts.
    private val EMAIL = Regex("""[^\s@]+@[^\s@]+\.[^\s@]+""")
}
