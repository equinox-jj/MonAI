package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakePaymentProviderRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshPaymentProvidersUseCaseTest {

    @Test
    fun `refreshes through the repository and returns its result`() = runTest {
        val repository = FakePaymentProviderRepository()
        repository.refreshResult = Outcome.Failure(WalletError.Network)

        assertEquals(Outcome.Failure(WalletError.Network), RefreshPaymentProvidersUseCase(repository)())
        assertEquals(1, repository.refreshCount)
    }
}
