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

    @Test
    fun `balance shares group wallets by type, largest first`() {
        val wallets = listOf(
            wallet(balance = 450_000, type = WalletType.CASH),
            wallet(balance = 8_250_000, type = WalletType.BANK),
            wallet(balance = 1_185_000, type = WalletType.E_WALLET),
            wallet(balance = 2_565_000, type = WalletType.BANK),
        )

        val shares = wallets.balanceSharesByType()

        assertEquals(listOf(WalletType.BANK, WalletType.E_WALLET, WalletType.CASH), shares.map { it.type })
        assertEquals(10_815_000.0 / 12_450_000, shares[0].share.toDouble(), 0.0001)
        assertEquals(1f, shares.sumOf { it.share.toDouble() }.toFloat(), 0.0001f)
    }

    @Test
    fun `balance shares skip archived wallets and count an overdrawn wallet as zero`() {
        val wallets = listOf(
            wallet(balance = 100_000, type = WalletType.BANK),
            wallet(balance = -50_000, type = WalletType.CASH),
            wallet(balance = 900_000, type = WalletType.E_WALLET, isArchived = true),
        )

        assertEquals(listOf(WalletTypeShare(WalletType.BANK, 1f)), wallets.balanceSharesByType())
    }

    @Test
    fun `balance shares are empty when nothing is positive`() {
        val shares = listOf(wallet(balance = 0), wallet(balance = -5)).balanceSharesByType()

        assertEquals(emptyList<WalletTypeShare>(), shares)
    }

    private fun wallet(balance: Long, isArchived: Boolean = false, type: WalletType = WalletType.CASH) = Wallet(
        id = "id-$balance",
        providerId = null,
        name = "Wallet",
        type = type,
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
