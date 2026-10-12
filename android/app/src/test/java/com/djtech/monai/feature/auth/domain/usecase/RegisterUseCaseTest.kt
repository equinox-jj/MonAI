package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.AuthResult
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RegisterUseCaseTest {

    private val repository = FakeAuthRepository()
    private val register = RegisterUseCase(repository)

    @Test
    fun `valid input registers through the repository`() = runTest {
        val result = register("Joshua", "joshua@example.com", "s3cretPass")

        assertEquals(AuthResult.Success(testUser), result)
        assertEquals(listOf("register(Joshua, joshua@example.com, s3cretPass)"), repository.calls)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = register("", "joshua@example.com", "s3cretPass")

        assertEquals(
            AuthResult.Failure(AuthError.InvalidFields(listOf(AuthFieldError(AuthField.NAME, "required")))),
            result,
        )
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.userResult = AuthResult.Failure(AuthError.EmailAlreadyRegistered)

        assertEquals(
            AuthResult.Failure(AuthError.EmailAlreadyRegistered),
            register("Joshua", "joshua@example.com", "s3cretPass"),
        )
    }
}
