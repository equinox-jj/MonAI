package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshUserUseCaseTest {

    private val repository = FakeProfileRepository()
    private val refreshUser = RefreshUserUseCase(repository)

    @Test
    fun `refreshes through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(ProfileError.Network)

        assertEquals(Outcome.Failure(ProfileError.Network), refreshUser())
        assertEquals(1, repository.refreshCount)
    }
}
