package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class GetWalletUseCaseTest {

    @Test
    fun `returns the cached wallet without fetching it`() = runTest {
        val repository = FakeWalletRepository(listOf(wallet("bca")))

        assertEquals(Outcome.Success(wallet("bca")), GetWalletUseCase(repository)("bca"))
        assertEquals(emptyList<String>(), repository.refreshedIds)
    }

    @Test
    fun `fetches a wallet that isn't cached`() = runTest {
        val repository = FakeWalletRepository()
        repository.remoteWallets = listOf(wallet("bca"))

        assertEquals(Outcome.Success(wallet("bca")), GetWalletUseCase(repository)("bca"))
        assertEquals(listOf("bca"), repository.refreshedIds)
    }

    @Test
    fun `fails like the fetch when it fails`() = runTest {
        val repository = FakeWalletRepository()
        repository.refreshWalletResult = Outcome.Failure(WalletError.Network)

        assertEquals(Outcome.Failure(WalletError.Network), GetWalletUseCase(repository)("bca"))
    }

    @Test
    fun `fails with NotFound when the fetch leaves nothing cached`() = runTest {
        assertEquals(Outcome.Failure(WalletError.NotFound), GetWalletUseCase(FakeWalletRepository())("bca"))
    }
}
