package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class DeleteWalletUseCaseTest {

    private val repository = FakeWalletRepository(listOf(wallet("bca", isDefault = true), wallet("ovo")))
    private val deleteWallet = DeleteWalletUseCase(repository)

    @Test
    fun `deletes a wallet that is not the default`() = runTest {
        assertEquals(Outcome.Success(Unit), deleteWallet("ovo"))
        assertEquals(listOf("ovo"), repository.deleted)
    }

    @Test
    fun `the default wallet can't be deleted`() = runTest {
        assertEquals(Outcome.Failure(WalletError.DefaultRequired), deleteWallet("bca"))
        assertEquals(emptyList<String>(), repository.deleted)
    }

    @Test
    fun `a wallet with transactions reports it, so the screen can offer archive`() = runTest {
        repository.deleteResult = Outcome.Failure(WalletError.HasTransactions)

        assertEquals(Outcome.Failure(WalletError.HasTransactions), deleteWallet("ovo"))
    }
}
