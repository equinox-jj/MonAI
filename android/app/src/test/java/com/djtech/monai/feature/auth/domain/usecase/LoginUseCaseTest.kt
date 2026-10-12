package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.AuthResult
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class LoginUseCaseTest {

    private val repository = FakeAuthRepository()
    private val login = LoginUseCase(repository)

    @Test
    fun `valid input logs in through the repository`() = runTest {
        val result = login("joshua@example.com", "s3cretPass")

        assertEquals(AuthResult.Success(testUser), result)
        assertEquals(listOf("login(joshua@example.com, s3cretPass)"), repository.calls)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = login("joshua@example.com", "")

        assertEquals(
            AuthResult.Failure(AuthError.InvalidFields(listOf(AuthFieldError(AuthField.PASSWORD, "required")))),
            result,
        )
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.userResult = AuthResult.Failure(AuthError.InvalidCredentials)

        assertEquals(AuthResult.Failure(AuthError.InvalidCredentials), login("joshua@example.com", "s3cretPass"))
    }
}
