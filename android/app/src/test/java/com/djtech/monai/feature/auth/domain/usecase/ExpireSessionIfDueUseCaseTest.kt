package com.djtech.monai.feature.auth.domain.usecase

import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ExpireSessionIfDueUseCaseTest {

    private val repository = FakeAuthRepository()
    private val expireSessionIfDue = ExpireSessionIfDueUseCase(repository)

    @Test
    fun `asks the repository to expire an overdue session`() = runTest {
        expireSessionIfDue()

        assertEquals(listOf("expireSessionIfDue"), repository.calls)
    }
}
