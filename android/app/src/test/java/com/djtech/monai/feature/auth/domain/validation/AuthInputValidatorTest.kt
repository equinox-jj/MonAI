package com.djtech.monai.feature.auth.domain.validation

import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
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
                AuthFieldError(AuthField.NAME, "required"),
                AuthFieldError(AuthField.EMAIL, "required"),
                AuthFieldError(AuthField.PASSWORD, "required"),
            ),
            AuthInputValidator.register("   ", " ", ""),
        )
    }

    @Test
    fun `name over 100 characters is too long`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NAME, "max_length", mapOf("max" to "100"))),
            AuthInputValidator.register("a".repeat(101), "joshua@example.com", "s3cretPass"),
        )
    }

    @Test
    fun `name length ignores surrounding spaces and counts emoji as one character`() {
        val name = "  " + "😀".repeat(100) + "  "

        assertEquals(noErrors, AuthInputValidator.register(name, "joshua@example.com", "s3cretPass"))
    }

    @Test
    fun `malformed email is invalid`() {
        listOf("joshua", "joshua@", "@example.com", "joshua@example", "jo shua@example.com").forEach { email ->
            assertEquals(
                email,
                listOf(AuthFieldError(AuthField.EMAIL, "invalid_format")),
                AuthInputValidator.register("Joshua", email, "s3cretPass"),
            )
        }
    }

    @Test
    fun `email is checked after trimming`() {
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "  Joshua@Example.com ", "s3cretPass"))
    }

    @Test
    fun `email over 254 characters is too long`() {
        val email = "a".repeat(243) + "@example.com"

        assertEquals(
            listOf(AuthFieldError(AuthField.EMAIL, "max_length", mapOf("max" to "254"))),
            AuthInputValidator.register("Joshua", email, "s3cretPass"),
        )
    }

    @Test
    fun `password must be 8 to 72 characters`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, "min_length", mapOf("min" to "8"))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "short12"),
        )
        assertEquals(
            listOf(AuthFieldError(AuthField.PASSWORD, "max_length", mapOf("max" to "72"))),
            AuthInputValidator.register("Joshua", "joshua@example.com", "a".repeat(73)),
        )
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "a".repeat(72)))
    }

    @Test
    fun `password is not trimmed`() {
        assertEquals(noErrors, AuthInputValidator.register("Joshua", "joshua@example.com", "        "))
    }

    // ---------------------------------------------------------------- login

    @Test
    fun `login needs a well-formed email and a password`() {
        assertEquals(noErrors, AuthInputValidator.login("joshua@example.com", "x"))
        assertEquals(
            listOf(
                AuthFieldError(AuthField.EMAIL, "invalid_format"),
                AuthFieldError(AuthField.PASSWORD, "required"),
            ),
            AuthInputValidator.login("joshua", ""),
        )
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
                AuthFieldError(AuthField.CURRENT_PASSWORD, "required"),
                AuthFieldError(AuthField.NEW_PASSWORD, "required"),
            ),
            AuthInputValidator.changePassword("", ""),
        )
    }

    @Test
    fun `new password must be 8 to 72 characters`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, "min_length", mapOf("min" to "8"))),
            AuthInputValidator.changePassword("oldPass1", "short"),
        )
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, "max_length", mapOf("max" to "72"))),
            AuthInputValidator.changePassword("oldPass1", "a".repeat(73)),
        )
    }

    @Test
    fun `new password must differ from the current one`() {
        assertEquals(
            listOf(AuthFieldError(AuthField.NEW_PASSWORD, "not_equal", mapOf("other" to "current_password"))),
            AuthInputValidator.changePassword("samePass1", "samePass1"),
        )
    }
}
