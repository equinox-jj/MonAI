package com.djtech.monai.feature.auth.domain.validation

import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import org.junit.Assert.assertEquals
import org.junit.Test

class AuthInputValidatorTest {

    private val noErrors = emptyList<AuthFieldError>()

    // ---------------------------------------------------------------- register

    @Test
    fun `valid registration has no errors`() {
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "s3cretPass"))
    }

    @Test
    fun `blank fields are required`() {
        assertEquals(
            listOf(
                AuthFieldError(AuthField.NAME, FieldIssue.Required),
                AuthFieldError(AuthField.EMAIL, FieldIssue.Required),
                AuthFieldError(AuthField.PASSWORD, FieldIssue.Required),
            ),
            AuthInputValidator.register("", "", ""),
        )
    }

    @Test
    fun `name over 100 characters is too long`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NAME, FieldIssue.TooLong(100))),
            AuthInputValidator.register("a".repeat(101), "joshua@example.com", "s3cretPass"),
        )
    }

    @Test
    fun `name length counts emoji as one character`() {
        val name = "😀".repeat(100)

        assertEquals(noErrors, AuthInputValidator.register(name, "joshua@example.com", "s3cretPass"))
    }

    @Test
    fun `malformed email is invalid`() {
        listOf("joshua", "joshua@", "@example.com", "joshua@example", "jo shua@example.com").forEach { email ->
            assertEquals(
                email,
                listOf(AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat)),
                AuthInputValidator.register("Joshua", email, "s3cretPass"),
            )
        }
    }

    @Test
    fun `email over 254 characters is too long`() {
        val email = "a".repeat(243) + "@example.com"

        assertEquals(
            listOf(AuthFieldError(AuthField.EMAIL, FieldIssue.TooLong(254))),
            AuthInputValidator.register("Joshua", email, "s3cretPass"),
        )
    }

    @Test
    fun `password must be 8 to 72 characters`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, FieldIssue.TooShort(8))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "short12"),
        )
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, FieldIssue.TooLong(72))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "a".repeat(73)),
        )
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "a".repeat(72)))
    }

    @Test
    fun `password minimum counts characters, not bytes`() {
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "😀".repeat(8)))
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, FieldIssue.TooShort(8))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "😀".repeat(7)),
        )
    }

    @Test
    fun `password maximum counts UTF-8 bytes, the bcrypt limit`() {
        // 18 emoji are 72 bytes; 19 are 76 bytes but only 19 characters.
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "😀".repeat(18)))
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, FieldIssue.TooLong(72))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "😀".repeat(19)),
        )
    }

    @Test
    fun `password is not trimmed`() {
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "        "))
    }

    // ---------------------------------------------------------------- login

    @Test
    fun `valid login has no errors`() {
        assertEquals(noErrors, AuthInputValidator.login("joshua@example.com", "s3cretPass"))
    }

    @Test
    fun `login needs a well-formed email and a password`() {
        assertEquals(
            listOf(
                AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat),
                AuthFieldError(AuthField.PASSWORD, FieldIssue.Required),
            ),
            AuthInputValidator.login("joshua", ""),
        )
    }

    @Test
    fun `login has no password minimum, so a short one fails as wrong credentials`() {
        assertEquals(noErrors, AuthInputValidator.login("joshua@example.com", "short12"))
    }

    @Test
    fun `login caps the password at 72 bytes`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, FieldIssue.TooLong(72))),
            AuthInputValidator.login("joshua@example.com", "a".repeat(73)),
        )
    }

    @Test
    fun `login does not cap the email length`() {
        assertEquals(noErrors, AuthInputValidator.login("a".repeat(243) + "@example.com", "s3cretPass"))
    }

    // ---------------------------------------------------------------- change password

    @Test
    fun `valid password change has no errors`() {
        assertEquals(noErrors, AuthInputValidator.changePassword("oldPass1", "newPass12"))
    }

    @Test
    fun `password change needs both passwords`() {
        assertEquals(
            listOf(
                AuthFieldError(AuthField.CURRENT_PASSWORD, FieldIssue.Required),
                AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.Required),
            ),
            AuthInputValidator.changePassword("", ""),
        )
    }

    @Test
    fun `new password must be 8 to 72 characters`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.TooShort(8))),
            AuthInputValidator.changePassword("oldPass1", "short"),
        )
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.TooLong(72))),
            AuthInputValidator.changePassword("oldPass1", "a".repeat(73)),
        )
    }

    @Test
    fun `new password must differ from the current one`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.SameAsCurrent)),
            AuthInputValidator.changePassword("samePass1", "samePass1"),
        )
    }
}
