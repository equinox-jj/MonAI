package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveAllWalletsUseCaseTest {

    @Test
    fun `emits every cached wallet, archived ones included`() = runTest {
        val wallets = listOf(wallet("bca"), wallet("dana", isArchived = true))
        val observeAllWallets = ObserveAllWalletsUseCase(FakeWalletRepository(wallets))

        assertEquals(wallets, observeAllWallets().first())
    }
}
