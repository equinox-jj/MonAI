package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class DeleteAccountUseCaseTest {

    private val repository = FakeProfileRepository(user())
    private val deleteAccount = DeleteAccountUseCase(repository)

    @Test
    fun `sends the password as typed`() = runTest {
        assertEquals(Outcome.Success(Unit), deleteAccount(" secret "))
        assertEquals(listOf(" secret "), repository.deletedWithPasswords)
    }

    @Test
    fun `needs a password`() = runTest {
        assertEquals(Outcome.Failure(ProfileError.PasswordRequired), deleteAccount(""))
        assertTrue(repository.deletedWithPasswords.isEmpty())
    }

    @Test
    fun `passes on a wrong password`() = runTest {
        repository.deleteError = ProfileError.WrongPassword

        assertEquals(Outcome.Failure(ProfileError.WrongPassword), deleteAccount("nope"))
    }
}
