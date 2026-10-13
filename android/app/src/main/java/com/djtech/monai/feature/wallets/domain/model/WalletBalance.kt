package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType

/** Rupiah across wallets that are not archived, the same rule as the API's `meta.total_balance`. */
fun List<Wallet>.totalBalance(): Long = filterNot(Wallet::isArchived).sumOf(Wallet::currentBalance)

/** One wallet type's part of the total, for the stacked bar on the Wallets total card. */
data class WalletTypeShare(
    val type: WalletType,
    /** 0..1. */
    val share: Float,
)

/**
 * How the money in wallets that are not archived splits by type, largest first. An overdrawn wallet
 * counts as zero, so the shares stay positive and add up to 1; empty when nothing is positive.
 */
fun List<Wallet>.balanceSharesByType(): List<WalletTypeShare> {
    val byType = filterNot(Wallet::isArchived)
        .groupBy(Wallet::type)
        .mapValues { (_, wallets) -> wallets.sumOf { it.currentBalance.coerceAtLeast(0) } }
        .filterValues { it > 0 }
    val total = byType.values.sum()
    if (total <= 0) return emptyList()
    return byType
        .map { (type, amount) -> WalletTypeShare(type, (amount.toDouble() / total).toFloat()) }
        .sortedByDescending(WalletTypeShare::share)
}
