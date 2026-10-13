package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ArchiveWalletUseCaseTest {

    private val repository = FakeWalletRepository(listOf(wallet("bca", isDefault = true), wallet("ovo")))
    private val archiveWallet = ArchiveWalletUseCase(repository)

    @Test
    fun `archives a wallet that is not the default`() = runTest {
        val result = archiveWallet("ovo")

        assertTrue(result is Outcome.Success)
        assertEquals(listOf("ovo" to WalletChanges(isArchived = true)), repository.updates)
    }

    @Test
    fun `the default wallet can't be archived`() = runTest {
        assertEquals(Outcome.Failure(WalletError.DefaultRequired), archiveWallet("bca"))
        assertEquals(emptyList<Pair<String, WalletChanges>>(), repository.updates)
    }

    @Test
    fun `a wallet missing from the cache is not found`() = runTest {
        assertEquals(Outcome.Failure(WalletError.NotFound), archiveWallet("gone"))
    }
}
