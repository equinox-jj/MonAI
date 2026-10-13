package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveArchivedWalletsUseCaseTest {

    @Test
    fun `emits only archived wallets, in the cache's order`() = runTest {
        val repository = FakeWalletRepository(
            listOf(
                wallet("bca", isDefault = true),
                wallet("mandiri", isArchived = true),
                wallet("ovo", isArchived = true),
            ),
        )

        assertEquals(
            listOf(wallet("mandiri", isArchived = true), wallet("ovo", isArchived = true)),
            ObserveArchivedWalletsUseCase(repository)().first(),
        )
    }
}
