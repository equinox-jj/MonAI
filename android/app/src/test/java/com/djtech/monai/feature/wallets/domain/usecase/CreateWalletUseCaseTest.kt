package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.repository.FakePaymentProviderRepository
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class CreateWalletUseCaseTest {

    private val wallets = FakeWalletRepository()
    private val providers = FakePaymentProviderRepository()
    private val createWallet = CreateWalletUseCase(wallets, providers)

    @Test
    fun `creates a custom wallet with the trimmed name`() = runTest {
        val result = createWallet(WalletInput(name = " Tabungan rumah ", type = WalletType.OTHER))

        assertTrue(result is Outcome.Success)
        assertEquals(listOf(WalletInput(name = "Tabungan rumah", type = WalletType.OTHER)), wallets.created)
        assertEquals(0, providers.refreshCount)
    }

    @Test
    fun `invalid input fails without calling the API`() = runTest {
        val result = createWallet(WalletInput(name = "", type = WalletType.OTHER))

        assertEquals(
            Outcome.Failure(
                WalletError.InvalidFields(listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.REQUIRED))),
            ),
            result,
        )
        assertEquals(emptyList<WalletInput>(), wallets.created)
    }

    @Test
    fun `a catalog provider is sent by id without refreshing`() = runTest {
        createWallet(WalletInput(providerId = "p-bca", providerSlug = "bca", name = "BCA", type = WalletType.BANK))

        assertEquals("p-bca", wallets.created.single().providerId)
        assertEquals(0, providers.refreshCount)
    }

    @Test
    fun `a seed provider is resolved to its server id by slug`() = runTest {
        providers.providers.value = listOf(paymentProvider("bca", id = ""))
        providers.catalogAfterRefresh = listOf(paymentProvider("bca", id = "p-bca"))

        createWallet(WalletInput(providerSlug = "bca", name = "BCA", type = WalletType.BANK))

        assertEquals(1, providers.refreshCount)
        assertEquals("p-bca", wallets.created.single().providerId)
    }

    @Test
    fun `a seed provider the server no longer lists becomes a custom wallet`() = runTest {
        providers.catalogAfterRefresh = listOf(paymentProvider("ovo", id = "p-ovo"))

        createWallet(WalletInput(providerSlug = "bca", name = "BCA", type = WalletType.BANK))

        val sent = wallets.created.single()
        assertEquals(null, sent.providerId)
        assertEquals(null, sent.providerSlug)
        assertEquals(WalletType.BANK, sent.type)
    }

    @Test
    fun `a failed catalog refresh stops the create`() = runTest {
        providers.refreshResult = Outcome.Failure(WalletError.Network)

        val result = createWallet(WalletInput(providerSlug = "bca", name = "BCA", type = WalletType.BANK))

        assertEquals(Outcome.Failure(WalletError.Network), result)
        assertEquals(emptyList<WalletInput>(), wallets.created)
    }

    @Test
    fun `returns the repository's failure`() = runTest {
        wallets.createResult = Outcome.Failure(WalletError.Unexpected)

        assertEquals(
            Outcome.Failure(WalletError.Unexpected),
            createWallet(WalletInput(name = "Cash 2", type = WalletType.CASH)),
        )
    }
}
