package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.Instant

class WalletBalanceTest {

    @Test
    fun `total balance sums the wallets that are not archived`() {
        val wallets = listOf(
            wallet(balance = 8_250_000),
            wallet(balance = 1_185_000),
            wallet(balance = 500_000, isArchived = true),
        )

        assertEquals(9_435_000L, wallets.totalBalance())
    }

    @Test
    fun `total balance keeps an overdrawn wallet negative`() {
        assertEquals(-15_000L, listOf(wallet(balance = 20_000), wallet(balance = -35_000)).totalBalance())
    }

    @Test
    fun `total balance of no wallets is zero`() {
        assertEquals(0L, emptyList<Wallet>().totalBalance())
    }

    private fun wallet(balance: Long, isArchived: Boolean = false) = Wallet(
        id = "id-$balance",
        providerId = null,
        name = "Wallet",
        type = WalletType.CASH,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = balance,
        icon = null,
        color = null,
        isDefault = false,
        isArchived = isArchived,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )
}
