package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshWalletUseCaseTest {

    @Test
    fun `refreshes the one wallet and returns the result`() = runTest {
        val repository = FakeWalletRepository()
        repository.refreshWalletResult = Outcome.Failure(WalletError.NotFound)

        assertEquals(Outcome.Failure(WalletError.NotFound), RefreshWalletUseCase(repository)("bca"))
        assertEquals(listOf("bca"), repository.refreshedIds)
    }
}
