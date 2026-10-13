package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ObserveWalletUseCaseTest {

    private val repository = FakeWalletRepository(listOf(wallet("bca"), wallet("ovo", isArchived = true)))
    private val observeWallet = ObserveWalletUseCase(repository)

    @Test
    fun `emits the wallet, archived or not`() = runTest {
        assertEquals(wallet("ovo", isArchived = true), observeWallet("ovo").first())
    }

    @Test
    fun `emits null for a wallet that isn't cached`() = runTest {
        assertNull(observeWallet("gone").first())
    }
}
