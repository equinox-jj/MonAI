package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class UpdateProfileUseCaseTest {

    private val repository = FakeProfileRepository(user(name = "Joshua", timezone = "Asia/Jakarta"))
    private val updateProfile = UpdateProfileUseCase(repository)

    @Test
    fun `sends only the trimmed fields that changed`() = runTest {
        assertEquals(Outcome.Success(Unit), updateProfile("  Joshua P  ", "Asia/Jakarta"))
        assertEquals(Outcome.Success(Unit), updateProfile("Joshua P", "Asia/Makassar"))

        assertEquals(
            listOf(ProfileChanges(name = "Joshua P"), ProfileChanges(timezone = "Asia/Makassar")),
            repository.updates,
        )
    }

    @Test
    fun `nothing changed sends nothing`() = runTest {
        assertEquals(Outcome.Success(Unit), updateProfile("Joshua", "Asia/Jakarta"))
        assertTrue(repository.updates.isEmpty())
    }

    @Test
    fun `refuses a blank or too long name without asking the server`() = runTest {
        assertEquals(
            Outcome.Failure(ProfileError.InvalidName(NameIssue.REQUIRED)),
            updateProfile("   ", "Asia/Jakarta"),
        )
        assertEquals(
            Outcome.Failure(ProfileError.InvalidName(NameIssue.TOO_LONG)),
            updateProfile("a".repeat(101), "Asia/Jakarta"),
        )
        assertTrue(repository.updates.isEmpty())
    }

    @Test
    fun `refuses an unknown timezone`() = runTest {
        assertEquals(Outcome.Failure(ProfileError.InvalidTimezone), updateProfile("Joshua", "Mars/Olympus"))
        assertTrue(repository.updates.isEmpty())
    }

    @Test
    fun `passes on the repository's failure`() = runTest {
        repository.updateError = ProfileError.Network

        assertEquals(Outcome.Failure(ProfileError.Network), updateProfile("Josh", "Asia/Jakarta"))
    }
}
