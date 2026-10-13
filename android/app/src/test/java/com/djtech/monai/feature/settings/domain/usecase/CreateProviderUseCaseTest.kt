package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.ProviderNameIssue
import com.djtech.monai.feature.settings.domain.repository.FakeAdminProviderRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class CreateProviderUseCaseTest {

    private val repository = FakeAdminProviderRepository()
    private val images = FakeImageProcessor()
    private val changes = ProviderChangeEvents()
    private val createProvider = CreateProviderUseCase(
        repository,
        ProviderLogoUploader(repository, images),
        changes,
    )

    @Test
    fun `creates the normalized provider`() = runTest {
        val input = input(name = " LinkAja ", aliases = listOf("LinkAja", "link aja"))

        val result = createProvider(input, logoUri = null)

        val saved = (result as Outcome.Success).data
        assertEquals("LinkAja", saved.provider.name)
        assertEquals(listOf("link aja", "linkaja"), saved.provider.aliases)
        assertNull(saved.logoError)
        assertEquals(listOf("create(LinkAja)"), repository.calls)
    }

    @Test
    fun `an inactive provider is deactivated after it is created`() = runTest {
        val result = createProvider(input(isActive = false), logoUri = null)

        assertFalse((result as Outcome.Success).data.provider.isActive)
        assertEquals(listOf("create(LinkAja)", "setActive(new-1, false)"), repository.calls)
    }

    @Test
    fun `uploads the logo as a small lossless webp`() = runTest {
        val result = createProvider(input(), logoUri = "content://logo")

        assertEquals("https://cdn.example.com/logos/new-1.webp", (result as Outcome.Success).data.provider.logoUrl)
        assertEquals(
            FakeImageProcessor.Fit(
                "content://logo",
                256,
                ImageEncoding.WEBP_LOSSLESS,
                512 * 1024,
            ),
            images.fits.single(),
        )
    }

    @Test
    fun `a logo that fails still saves the provider`() = runTest {
        repository.logoError = AdminProviderError.LogoTooLarge

        val result = createProvider(input(), logoUri = "content://logo")

        val saved = (result as Outcome.Success).data
        assertEquals(AdminProviderError.LogoTooLarge, saved.logoError)
        assertTrue(repository.providers.isNotEmpty())
    }

    @Test
    fun `a blank name fails without a request`() = runTest {
        assertEquals(
            Outcome.Failure(AdminProviderError.InvalidName(ProviderNameIssue.REQUIRED)),
            createProvider(input(name = "  "), logoUri = null),
        )
        assertTrue(repository.calls.isEmpty())
    }

    @Test
    fun `a taken slug or alias fails`() = runTest {
        repository.createError = AdminProviderError.Conflict

        assertEquals(Outcome.Failure(AdminProviderError.Conflict), createProvider(input(), logoUri = null))
    }

    private fun input(
        name: String = "LinkAja",
        aliases: List<String> = listOf("linkaja"),
        isActive: Boolean = true,
    ) = ProviderInput(
        name = name,
        type = WalletType.E_WALLET,
        aliases = aliases,
        sortOrder = 100,
        isActive = isActive,
    )
}
