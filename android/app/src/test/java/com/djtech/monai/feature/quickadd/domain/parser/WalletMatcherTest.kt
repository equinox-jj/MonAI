package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.core.model.wallet
import org.junit.Assert.assertEquals
import org.junit.Test

class WalletMatcherTest {

    private val gopayProvider = paymentProvider("gopay", name = "GoPay")
        .copy(aliases = listOf("gopay", "gpay", "go-pay"))
    private val bcaProvider = paymentProvider("bca", name = "BCA")
    private val wallets = listOf(
        wallet("w-gopay", name = "GoPay", providerId = gopayProvider.id, type = WalletType.E_WALLET),
        wallet("w-bca", name = "BCA Tabungan", providerId = bcaProvider.id, isDefault = true),
        wallet("w-cash", name = "Dompet", type = WalletType.CASH),
    )
    private val matcher = WalletMatcher(wallets, listOf(gopayProvider, bcaProvider))

    @Test
    fun `matches wallet names and provider aliases`() {
        assertEquals(listOf("w-gopay"), matcher.findAll("makan pakai gpay").map { it.walletId })
        assertEquals(listOf("w-bca"), matcher.findAll("bayar via bca tabungan").map { it.walletId })
        assertEquals(listOf("w-bca"), matcher.findAll("bayar via bca").map { it.walletId })
        assertEquals(listOf("w-cash"), matcher.findAll("parkir tunai").map { it.walletId })
    }

    @Test
    fun `the word before a wallet gives its role and is part of the match`() {
        val text = "topup gopay 100rb dari bca"
        val matches = matcher.findAll(text)

        assertEquals(listOf(WalletRole.UNSPECIFIED, WalletRole.SOURCE), matches.map { it.role })
        assertEquals("dari bca", text.substring(matches[1].range))
        assertEquals(WalletRole.DESTINATION, matcher.findAll("pindah ke gopay").single().role)
    }

    @Test
    fun `an exact name is more certain than a shared alias`() {
        assertEquals(0.95, matcher.findAll("pakai gopay").single().confidence, 0.0)
        val bothBca = WalletMatcher(
            wallets + wallet("w-bca2", name = "BCA Bisnis", providerId = bcaProvider.id),
            listOf(bcaProvider),
        )
        val match = bothBca.findAll("pakai bca").single()

        assertEquals("w-bca", match.walletId)
        assertEquals(true, match.confidence < 0.95)
    }

    @Test
    fun `does not match inside other words`() {
        assertEquals(emptyList<WalletMatch>(), matcher.findAll("abcabc"))
    }
}
