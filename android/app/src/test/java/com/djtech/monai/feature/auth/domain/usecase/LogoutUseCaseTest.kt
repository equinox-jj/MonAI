package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.auth.domain.model.AuthError
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class LogoutUseCaseTest {

    private val repository = FakeAuthRepository()

    @Test
    fun `signs out of this device`() = runTest {
        assertEquals(Outcome.Success(Unit), LogoutUseCase(repository)())
        assertEquals(listOf("logout"), repository.calls)
    }

    @Test
    fun `signs out of every device`() = runTest {
        repository.unitResult = Outcome.Failure(AuthError.Network)

        assertEquals(Outcome.Failure(AuthError.Network), LogoutAllDevicesUseCase(repository)())
        assertEquals(listOf("logoutAllDevices"), repository.calls)
    }
}
