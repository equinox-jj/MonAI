package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class SetDefaultWalletUseCaseTest {

    private val repository = FakeWalletRepository(listOf(wallet("bca", isDefault = true), wallet("ovo")))
    private val setDefault = SetDefaultWalletUseCase(repository)

    @Test
    fun `sends is_default true`() = runTest {
        setDefault("ovo")

        assertEquals(listOf("ovo" to WalletChanges(isDefault = true)), repository.updates)
    }

    @Test
    fun `returns the repository's failure`() = runTest {
        repository.updateResult = Outcome.Failure(WalletError.Network)

        assertEquals(Outcome.Failure(WalletError.Network), setDefault("ovo"))
    }
}
