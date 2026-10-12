package com.djtech.monai.feature.auth.presentation.common

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

class AuthErrorTextTest {

    @Test
    fun `required names the field`() {
        assertEquals(UiText.Resource(R.string.auth_field_name_required), FieldIssue.Required.toUiText(AuthField.NAME))
        assertEquals(UiText.Resource(R.string.auth_field_email_required), FieldIssue.Required.toUiText(AuthField.EMAIL))
        assertEquals(
            UiText.Resource(R.string.auth_field_password_required),
            FieldIssue.Required.toUiText(AuthField.PASSWORD),
        )
    }

    @Test
    fun `length issues carry their limit`() {
        assertEquals(
            UiText.Resource(R.string.auth_field_too_short, 8),
            FieldIssue.TooShort(8).toUiText(AuthField.PASSWORD),
        )
        assertEquals(
            UiText.Resource(R.string.auth_field_too_long, 100),
            FieldIssue.TooLong(100).toUiText(AuthField.NAME),
        )
    }

    @Test
    fun `format and unknown issues`() {
        assertEquals(
            UiText.Resource(R.string.auth_field_email_invalid),
            FieldIssue.InvalidFormat.toUiText(AuthField.EMAIL),
        )
        assertEquals(UiText.Resource(R.string.auth_field_invalid), FieldIssue.Invalid.toUiText(AuthField.NAME))
    }

    @Test
    fun `form errors map to banners`() {
        assertEquals(
            UiText.Resource(R.string.auth_error_invalid_credentials),
            AuthError.InvalidCredentials.toFormErrorText(),
        )
        assertEquals(UiText.Resource(R.string.auth_error_rate_limited), AuthError.RateLimited(null).toFormErrorText())
        assertEquals(UiText.Resource(R.string.auth_error_network), AuthError.Network.toFormErrorText())
        assertEquals(UiText.Resource(R.string.auth_error_unexpected), AuthError.Unexpected.toFormErrorText())
    }

    @Test
    fun `a known rate-limit wait is shown in whole minutes, rounded up`() {
        assertEquals(
            UiText.Plural(R.plurals.auth_error_rate_limited_wait, 2, 2),
            AuthError.RateLimited(90.seconds).toFormErrorText(),
        )
        assertEquals(
            UiText.Plural(R.plurals.auth_error_rate_limited_wait, 1, 1),
            AuthError.RateLimited(20.seconds).toFormErrorText(),
        )
        assertEquals(
            UiText.Plural(R.plurals.auth_error_rate_limited_wait, 15, 15),
            AuthError.RateLimited(15.minutes).toFormErrorText(),
        )
    }

    @Test
    fun `fieldMessage picks the first issue of the field`() {
        val errors = listOf(
            AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat),
            AuthFieldError(AuthField.EMAIL, FieldIssue.Required),
        )

        assertEquals(UiText.Resource(R.string.auth_field_email_invalid), errors.fieldMessage(AuthField.EMAIL))
        assertNull(errors.fieldMessage(AuthField.PASSWORD))
    }
}
