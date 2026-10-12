package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ObserveUserUseCaseTest {

    private val repository = FakeProfileRepository()
    private val observeUser = ObserveUserUseCase(repository)

    @Test
    fun `emits the cached user, or null before it is fetched`() = runTest {
        assertNull(observeUser().first())

        repository.user.value = user()

        assertEquals(user(), observeUser().first())
    }
}
