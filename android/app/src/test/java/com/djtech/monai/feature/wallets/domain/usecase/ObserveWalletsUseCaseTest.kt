package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveWalletsUseCaseTest {

    @Test
    fun `emits the wallets that are not archived`() = runTest {
        val repository = FakeWalletRepository(listOf(wallet("bca"), wallet("ovo", isArchived = true)))

        assertEquals(listOf(wallet("bca")), ObserveWalletsUseCase(repository)().first())
    }
}
