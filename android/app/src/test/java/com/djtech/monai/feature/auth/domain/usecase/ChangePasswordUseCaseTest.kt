package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.AuthResult
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ChangePasswordUseCaseTest {

    private val repository = FakeAuthRepository()
    private val changePassword = ChangePasswordUseCase(repository)

    @Test
    fun `valid input changes the password through the repository`() = runTest {
        val result = changePassword("oldPass1", "newPass12")

        assertEquals(AuthResult.Success(Unit), result)
        assertEquals(listOf("changePassword(oldPass1, newPass12)"), repository.calls)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = changePassword("samePass1", "samePass1")

        val error = AuthFieldError(AuthField.NEW_PASSWORD, "not_equal", mapOf("other" to "current_password"))
        assertEquals(AuthResult.Failure(AuthError.InvalidFields(listOf(error))), result)
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.unitResult = AuthResult.Failure(AuthError.WrongCurrentPassword)

        assertEquals(AuthResult.Failure(AuthError.WrongCurrentPassword), changePassword("oldPass1", "newPass12"))
    }
}
