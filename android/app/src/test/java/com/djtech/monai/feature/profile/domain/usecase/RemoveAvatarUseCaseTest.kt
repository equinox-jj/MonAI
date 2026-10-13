package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class RemoveAvatarUseCaseTest {

    @Test
    fun `removes the photo through the repository`() = runTest {
        val repository = FakeProfileRepository(user(avatarUrl = "https://cdn.example.com/a.webp"))

        assertEquals(Outcome.Success(Unit), RemoveAvatarUseCase(repository)())
        assertEquals(1, repository.removeAvatarCount)
        assertNull(repository.user.value?.avatarUrl)
    }
}
