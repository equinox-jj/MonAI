package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class UnarchiveWalletUseCaseTest {

    private val repository = FakeWalletRepository(listOf(wallet("ovo", isArchived = true)))

    @Test
    fun `sends is_archived false and returns the wallet`() = runTest {
        val result = UnarchiveWalletUseCase(repository)("ovo")

        assertEquals(listOf("ovo" to WalletChanges(isArchived = false)), repository.updates)
        assertEquals(Outcome.Success(wallet("ovo")), result)
    }
}
