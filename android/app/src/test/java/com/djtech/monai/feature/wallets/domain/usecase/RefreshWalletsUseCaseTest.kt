package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshWalletsUseCaseTest {

    private val repository = FakeWalletRepository()
    private val refreshWallets = RefreshWalletsUseCase(repository)

    @Test
    fun `refreshes through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(WalletError.Unexpected)

        assertEquals(Outcome.Failure(WalletError.Unexpected), refreshWallets())
        assertEquals(1, repository.refreshCount)
    }
}
