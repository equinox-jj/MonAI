package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType

/** What the word before a wallet says about it: `dari bca` pays from it, `ke gopay` moves money into it. */
enum class WalletRole { SOURCE, DESTINATION, UNSPECIFIED }

/** A wallet named in lowercase quick-add text. [range] includes the marker word before it. */
data class WalletMatch(val walletId: String, val range: IntRange, val role: WalletRole, val confidence: Double)

/** Finds the user's wallets by name, by their provider's name and aliases, and cash wallets by `cash`/`tunai`. */
class WalletMatcher(wallets: List<Wallet>, providers: List<PaymentProvider>) {

    private class Term(val text: String, val walletId: String, val confidence: Double)

    // Longest first, so "bca tabungan" wins over the "bca" alias.
    private val terms: List<Term> = buildTerms(wallets, providers).sortedByDescending { it.text.length }

    fun findAll(text: String): List<WalletMatch> {
        val taken = mutableListOf<IntRange>()
        val matches = mutableListOf<WalletMatch>()
        for (term in terms) {
            val regex = Regex("""(?<![\w-])${Regex.escape(term.text)}(?![\w-])""")
            for (found in regex.findAll(text)) {
                if (taken.any { it.overlaps(found.range) }) continue
                taken += found.range
                val marker = MARKER.find(text.substring(0, found.range.first))
                val role = marker?.let { roleOf(it.groupValues[1]) } ?: WalletRole.UNSPECIFIED
                val start = marker?.range?.first ?: found.range.first
                matches += WalletMatch(term.walletId, start..found.range.last, role, term.confidence)
            }
        }
        return matches.sortedBy { it.range.first }
    }

    private companion object {
        const val NAME = 0.95
        const val SHARED_ALIAS = 0.75

        val CASH_WORDS = listOf("cash", "tunai", "uang tunai")

        // The marker must end right before the wallet name.
        val MARKER = Regex("""(?<!\w)(pakai|pake|pakek|via|lewat|dari|from|with|using|pakai kartu|ke|to|into)\s+$""")

        fun roleOf(marker: String) = when (marker) {
            "ke", "to", "into" -> WalletRole.DESTINATION
            else -> WalletRole.SOURCE
        }

        fun IntRange.overlaps(other: IntRange) = first <= other.last && other.first <= last

        fun buildTerms(wallets: List<Wallet>, providers: List<PaymentProvider>): List<Term> {
            val providersById = providers.associateBy { it.id }
            val names = wallets.map { Term(it.name.lowercase().trim(), it.id, NAME) }
            // An alias shared by several wallets (two BCA accounts) goes to the default one, less surely.
            val aliases = wallets
                .flatMap { wallet -> aliasesOf(wallet, providersById).map { it to wallet } }
                .groupBy({ it.first }, { it.second })
                .filterKeys { alias -> names.none { it.text == alias } }
                .map { (alias, owners) ->
                    val owner = owners.firstOrNull { it.isDefault } ?: owners.first()
                    Term(alias, owner.id, if (owners.size == 1) NAME else SHARED_ALIAS)
                }
            return (names + aliases).filter { it.text.isNotEmpty() }
        }

        fun aliasesOf(wallet: Wallet, providersById: Map<String, PaymentProvider>): List<String> {
            val provider = wallet.providerId?.let(providersById::get)
            val providerTerms = provider?.let { it.aliases + it.name }.orEmpty()
            val cashTerms = if (wallet.type == WalletType.CASH) CASH_WORDS else emptyList()
            return (providerTerms + cashTerms).map { it.lowercase().trim() }.distinct()
        }
    }
}
