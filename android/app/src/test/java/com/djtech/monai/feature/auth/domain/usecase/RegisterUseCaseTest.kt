package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RegisterUseCaseTest {

    private val repository = FakeAuthRepository()
    private val register = RegisterUseCase(repository)

    @Test
    fun `valid input registers through the repository`() = runTest {
        val result = register("Joshua", "joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Success(testUser), result)
        assertEquals(listOf("register(Joshua, joshua@example.com, s3cretPass)"), repository.calls)
    }

    @Test
    fun `name and email are sent trimmed, the email lowercased, the password as typed`() = runTest {
        register(" Joshua ", "  Joshua@Example.com ", " s3cretPass ")

        assertEquals(listOf("register(Joshua, joshua@example.com,  s3cretPass )"), repository.calls)
    }

    @Test
    fun `a name of only spaces is required`() = runTest {
        val result = register("   ", "joshua@example.com", "s3cretPass")

        assertEquals(
            Outcome.Failure(AuthError.InvalidFields(listOf(AuthFieldError(AuthField.NAME, FieldIssue.Required)))),
            result,
        )
    }

    @Test
    fun `surrounding spaces don't count toward the name limit`() = runTest {
        val result = register("  " + "a".repeat(100) + "  ", "joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Success(testUser), result)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = register("", "joshua@example.com", "s3cretPass")

        assertEquals(
            Outcome.Failure(AuthError.InvalidFields(listOf(AuthFieldError(AuthField.NAME, FieldIssue.Required)))),
            result,
        )
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.userResult = Outcome.Failure(AuthError.EmailAlreadyRegistered)

        assertEquals(
            Outcome.Failure(AuthError.EmailAlreadyRegistered),
            register("Joshua", "joshua@example.com", "s3cretPass"),
        )
    }
}
