package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class LoginUseCaseTest {

    private val repository = FakeAuthRepository()
    private val login = LoginUseCase(repository)

    @Test
    fun `valid input logs in through the repository`() = runTest {
        val result = login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Success(testUser), result)
        assertEquals(listOf("login(joshua@example.com, s3cretPass)"), repository.calls)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = login("joshua@example.com", "")

        val error = AuthFieldError(AuthField.PASSWORD, FieldIssue.Required)
        assertEquals(Outcome.Failure(AuthError.InvalidFields(listOf(error))), result)
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.userResult = Outcome.Failure(AuthError.InvalidCredentials)

        assertEquals(Outcome.Failure(AuthError.InvalidCredentials), login("joshua@example.com", "s3cretPass"))
    }
}
