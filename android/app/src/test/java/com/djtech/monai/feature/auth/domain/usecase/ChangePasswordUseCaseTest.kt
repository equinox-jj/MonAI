package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ChangePasswordUseCaseTest {

    private val repository = FakeAuthRepository()
    private val changePassword = ChangePasswordUseCase(repository)

    @Test
    fun `valid input changes the password through the repository`() = runTest {
        val result = changePassword("oldPass1", "newPass12")

        assertEquals(Outcome.Success(Unit), result)
        assertEquals(listOf("changePassword(oldPass1, newPass12)"), repository.calls)
    }

    @Test
    fun `invalid input fails without calling the repository`() = runTest {
        val result = changePassword("samePass1", "samePass1")

        val error = AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.SameAsCurrent)
        assertEquals(Outcome.Failure(AuthError.InvalidFields(listOf(error))), result)
        assertEquals(emptyList<String>(), repository.calls)
    }

    @Test
    fun `repository failure is passed through`() = runTest {
        repository.unitResult = Outcome.Failure(AuthError.WrongCurrentPassword)

        assertEquals(Outcome.Failure(AuthError.WrongCurrentPassword), changePassword("oldPass1", "newPass12"))
    }
}
