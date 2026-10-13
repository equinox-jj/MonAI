package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.repository.FakeAdminProviderRepository
import com.djtech.monai.feature.settings.domain.repository.adminProvider
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class UpdateProviderUseCaseTest {

    private val ovo = adminProvider(
        "ovo",
        name = "OVO",
        type = WalletType.E_WALLET,
        aliases = listOf("ovo"),
        sortOrder = 70,
    )
    private val repository = FakeAdminProviderRepository(listOf(ovo))
    private val updateProvider = UpdateProviderUseCase(
        repository,
        ProviderLogoUploader(repository, FakeImageProcessor()),
        ProviderChangeEvents(),
    )

    @Test
    fun `sends only what changed`() = runTest {
        val result = updateProvider(ovo, input(aliases = listOf("ovo", "OVO Cash")), logoUri = null)

        assertEquals(listOf("ovo", "ovo cash"), (result as Outcome.Success).data.provider.aliases)
        val changes = ProviderChanges(aliases = listOf("ovo", "ovo cash"))
        assertEquals(listOf("update(ovo, $changes)"), repository.calls)
    }

    @Test
    fun `nothing changed sends nothing`() = runTest {
        val result = updateProvider(ovo, input(), logoUri = null)

        assertEquals(ovo, (result as Outcome.Success).data.provider)
        assertTrue(repository.calls.isEmpty())
    }

    @Test
    fun `switching active off deactivates it`() = runTest {
        updateProvider(ovo, input(isActive = false), logoUri = null)

        assertEquals(listOf("setActive(ovo, false)"), repository.calls)
    }

    @Test
    fun `a locked system provider fails`() = runTest {
        repository.statusError = AdminProviderError.Locked

        assertEquals(Outcome.Failure(AdminProviderError.Locked), updateProvider(ovo, input(isActive = false), null))
    }

    private fun input(aliases: List<String> = listOf("ovo"), isActive: Boolean = true) = ProviderInput(
        name = "OVO",
        type = WalletType.E_WALLET,
        aliases = aliases,
        sortOrder = 70,
        isActive = isActive,
    )
}
