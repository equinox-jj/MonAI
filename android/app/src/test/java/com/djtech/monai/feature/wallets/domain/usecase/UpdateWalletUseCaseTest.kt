package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class UpdateWalletUseCaseTest {

    private val mandiri = wallet(
        "mdr",
        name = "Mandiri",
        providerId = "p-mandiri",
        initialBalance = 2_000_000,
        color = "#4A45D6",
    )
    private val repository = FakeWalletRepository(listOf(mandiri))
    private val updateWallet = UpdateWalletUseCase(repository)

    @Test
    fun `sends only the fields that changed`() = runTest {
        val edited = mandiri.asInput().copy(name = " Mandiri Bisnis ", initialBalance = 2_500_000)

        val result = updateWallet(mandiri, edited)

        assertTrue(result is Outcome.Success)
        assertEquals(
            listOf("mdr" to WalletChanges(name = "Mandiri Bisnis", initialBalance = 2_500_000)),
            repository.updates,
        )
    }

    @Test
    fun `an unchanged form succeeds without a call`() = runTest {
        assertEquals(Outcome.Success(mandiri), updateWallet(mandiri, mandiri.asInput().copy(name = "Mandiri ")))
        assertEquals(emptyList<Pair<String, WalletChanges>>(), repository.updates)
    }

    @Test
    fun `sends a new color and type`() = runTest {
        updateWallet(mandiri, mandiri.asInput().copy(color = "#0891B2", type = WalletType.OTHER))

        assertEquals(WalletChanges(type = WalletType.OTHER, color = "#0891B2"), repository.updates.single().second)
    }

    @Test
    fun `making it the default sends is_default, and never sends false`() = runTest {
        updateWallet(mandiri, mandiri.asInput().copy(isDefault = true))
        val default = mandiri.copy(isDefault = true)
        updateWallet(default, default.asInput().copy(isDefault = false))

        assertEquals(listOf("mdr" to WalletChanges(isDefault = true)), repository.updates)
    }

    @Test
    fun `invalid input fails without calling the API`() = runTest {
        val result = updateWallet(mandiri, mandiri.asInput().copy(name = ""))

        assertEquals(
            Outcome.Failure(
                WalletError.InvalidFields(listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.REQUIRED))),
            ),
            result,
        )
        assertEquals(emptyList<Pair<String, WalletChanges>>(), repository.updates)
    }

    private fun Wallet.asInput() = WalletInput(
        providerId = providerId,
        name = name,
        type = type,
        initialBalance = initialBalance,
        color = color,
        isDefault = isDefault,
    )
}
