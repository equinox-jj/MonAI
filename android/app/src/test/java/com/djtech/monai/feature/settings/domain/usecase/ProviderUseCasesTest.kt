package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.repository.FakeAdminProviderRepository
import com.djtech.monai.feature.settings.domain.repository.adminProvider
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** The pass-through provider use cases. */
class ProviderUseCasesTest {

    private val repository = FakeAdminProviderRepository(
        listOf(adminProvider("bca", sortOrder = 20), adminProvider("cash", sortOrder = 0, isSystem = true)),
    )

    @Test
    fun `lists providers by sort order`() = runTest {
        val result = GetAdminProvidersUseCase(repository)()

        assertEquals(listOf("cash", "bca"), (result as Outcome.Success).data.map { it.id })
    }

    @Test
    fun `gets one provider`() = runTest {
        assertEquals("bca", (GetAdminProviderUseCase(repository)("bca") as Outcome.Success).data.id)
        assertEquals(Outcome.Failure(AdminProviderError.NotFound), GetAdminProviderUseCase(repository)("gone"))
    }

    @Test
    fun `sets the status`() = runTest {
        val result = SetProviderActiveUseCase(repository, ProviderChangeEvents())("bca", active = false)

        assertEquals(false, (result as Outcome.Success).data.isActive)
    }

    @Test
    fun `deletes a provider`() = runTest {
        assertEquals(Outcome.Success(Unit), DeleteProviderUseCase(repository, ProviderChangeEvents())("bca"))
        assertTrue(repository.providers.none { it.id == "bca" })
    }

    @Test
    fun `successful changes are announced`() = runTest {
        val events = ProviderChangeEvents()
        val announced = mutableListOf<String>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) {
            ObserveProviderChangesUseCase(events)().toList(announced)
        }

        SetProviderActiveUseCase(repository, events)("bca", active = false)
        DeleteProviderUseCase(repository, events)("gone")
        DeleteProviderUseCase(repository, events)("bca")

        assertEquals(listOf("bca", "gone", "bca"), announced)
    }
}
