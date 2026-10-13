package com.djtech.monai.feature.wallets.domain.validation

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class WalletInputValidatorTest {

    @Test
    fun `a complete custom wallet is valid`() {
        assertEquals(emptyList<WalletFieldError>(), CUSTOM.validate())
    }

    @Test
    fun `normalizing trims the name and drops a blank color`() {
        val input = CUSTOM.copy(name = "  Tabungan rumah  ", color = " ").normalized()

        assertEquals("Tabungan rumah", input.name)
        assertNull(input.color)
    }

    @Test
    fun `a custom wallet needs a name and a type`() {
        assertEquals(
            listOf(
                WalletFieldError(WalletField.NAME, WalletFieldIssue.REQUIRED),
                WalletFieldError(WalletField.TYPE, WalletFieldIssue.REQUIRED),
            ),
            CUSTOM.copy(name = "", type = null).validate(),
        )
    }

    @Test
    fun `a provider wallet takes its type from the provider`() {
        val fromSeed = CUSTOM.copy(providerSlug = "bca", type = null)
        val fromCatalog = CUSTOM.copy(providerId = "p-bca", type = null)

        assertEquals(emptyList<WalletFieldError>(), fromSeed.validate())
        assertEquals(emptyList<WalletFieldError>(), fromCatalog.validate())
    }

    @Test
    fun `names longer than the API's limit are too long`() {
        assertEquals(emptyList<WalletFieldError>(), CUSTOM.copy(name = "a".repeat(MAX_WALLET_NAME_LENGTH)).validate())
        assertEquals(
            listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.TOO_LONG)),
            CUSTOM.copy(name = "a".repeat(MAX_WALLET_NAME_LENGTH + 1)).validate(),
        )
    }

    @Test
    fun `the starting balance must be between zero and the API's limit`() {
        assertEquals(emptyList<WalletFieldError>(), CUSTOM.copy(initialBalance = MAX_INITIAL_BALANCE).validate())
        assertEquals(
            listOf(WalletFieldError(WalletField.INITIAL_BALANCE, WalletFieldIssue.TOO_LARGE)),
            CUSTOM.copy(initialBalance = MAX_INITIAL_BALANCE + 1).validate(),
        )
        assertEquals(
            listOf(WalletFieldError(WalletField.INITIAL_BALANCE, WalletFieldIssue.INVALID)),
            CUSTOM.copy(initialBalance = -1).validate(),
        )
    }

    @Test
    fun `colors must be RRGGBB hex`() {
        assertEquals(emptyList<WalletFieldError>(), CUSTOM.copy(color = "#0e7490").validate())
        assertEquals(
            listOf(WalletFieldError(WalletField.COLOR, WalletFieldIssue.INVALID)),
            CUSTOM.copy(color = "teal").validate(),
        )
    }

    private companion object {
        val CUSTOM = WalletInput(name = "Tabungan rumah", type = WalletType.OTHER, initialBalance = 1_250_000)
    }
}
