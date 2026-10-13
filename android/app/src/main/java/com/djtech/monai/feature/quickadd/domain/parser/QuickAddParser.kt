package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.DraftConfidence
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.categoryType
import java.time.LocalDate

/** What the parser matches against: the user's active wallets, visible categories and the provider catalog. */
data class ParseContext(
    val wallets: List<Wallet>,
    val categories: List<Category>,
    val providers: List<PaymentProvider>,
    val today: LocalDate,
) {
    val defaultWalletId: String? get() = (wallets.firstOrNull { it.isDefault } ?: wallets.firstOrNull())?.id
}

/**
 * Layer 1 of quick add: turns a phrase into drafts on the phone, without calling the API.
 * Every field it can't read is null with confidence 0; guesses (the default wallet, "Other") are low.
 */
object QuickAddParser {

    private const val DEFAULT_DATE = 0.9
    private const val DEFAULT_WALLET = 0.5
    private const val FALLBACK_CATEGORY = 0.3
    private const val NOT_NEEDED = 1.0

    fun parse(text: String, context: ParseContext): List<TransactionDraft> {
        val phrase = text.lowercase().replace(Regex("""\s+"""), " ").trim()
        if (phrase.isEmpty()) return emptyList()
        val walletMatcher = WalletMatcher(context.wallets, context.providers)
        val segments = PhraseSplitter.split(phrase) { readSegment(it, context, walletMatcher).amount != null }
        val parts = segments.map { readSegment(it, context, walletMatcher) }
        // A date or a single wallet said once ("... kmrn", "... pakai gopay") applies to every part.
        val sharedDate = parts.firstNotNullOfOrNull { it.date }
        val sharedWallets = parts.flatMap { it.wallets }.takeIf { it.size == 1 }.orEmpty()
        return parts.map { part ->
            part.toDraft(
                date = part.date ?: sharedDate,
                wallets = part.wallets.ifEmpty { sharedWallets },
                context = context,
            )
        }
    }

    private class Segment(
        val text: String,
        val amount: AmountMatch?,
        val date: DateMatch?,
        val wallets: List<WalletMatch>,
        val note: String?,
    )

    private fun readSegment(text: String, context: ParseContext, walletMatcher: WalletMatcher): Segment {
        val date = DateParser.find(text, context.today)
        val wallets = walletMatcher.findAll(text)
        val taken = listOfNotNull(date?.range) + wallets.map { it.range }
        val amounts = AmountParser.findAll(text).filter { amount -> taken.none { it.overlaps(amount.range) } }
        // "beli 2 kopi 50rb": the clearer amount wins; on a tie, the last one.
        val amount = amounts.maxWithOrNull(compareBy<AmountMatch> { it.confidence }.thenBy { it.range.first })
        val note = noteOf(text, taken + amounts.map { it.range })
        return Segment(text, amount, date, wallets, note)
    }

    private fun Segment.toDraft(date: DateMatch?, wallets: List<WalletMatch>, context: ParseContext): TransactionDraft {
        val hint = TypeHints.detect(text)
        val isTransfer = hint.type == TransactionType.TRANSFER
        val destination = if (isTransfer) {
            wallets.firstOrNull { it.role == WalletRole.DESTINATION }
                ?: wallets.firstOrNull { it.role == WalletRole.UNSPECIFIED }
        } else {
            null
        }
        val source = wallets.firstOrNull { it != destination }
        val walletId = source?.walletId ?: context.defaultWalletId?.takeIf { it != destination?.walletId }
        val walletConfidence = when {
            source != null -> source.confidence
            walletId != null -> DEFAULT_WALLET
            else -> 0.0
        }
        val category = if (isTransfer) null else categoryOf(hint.type, context.categories)
        return TransactionDraft(
            type = hint.type,
            amount = amount?.amount,
            walletId = walletId,
            toWalletId = destination?.walletId,
            categoryId = category?.categoryId,
            date = date?.date ?: context.today,
            note = note,
            merchant = null,
            confidence = DraftConfidence(
                type = hint.confidence,
                amount = amount?.confidence ?: 0.0,
                wallet = walletConfidence,
                category = if (isTransfer) NOT_NEEDED else category?.confidence ?: 0.0,
                date = date?.confidence ?: DEFAULT_DATE,
            ),
        )
    }

    private fun Segment.categoryOf(type: TransactionType, categories: List<Category>): CategoryMatch? {
        val categoryType = type.categoryType() ?: return null
        return CategoryKeywords.find(text, categories, categoryType)
            ?: categories.firstOrNull { it.type == categoryType && it.isSystem }
                ?.let { CategoryMatch(it.id, FALLBACK_CATEGORY) }
    }

    /** [text] without the parsed parts, tidied and capitalized: "makan siang 35rb pakai gopay" → "Makan siang". */
    private fun noteOf(text: String, parsed: List<IntRange>): String? {
        val kept = text.filterIndexed { index, _ -> parsed.none { index in it } }
        return kept.replace(Regex("""\s+"""), " ")
            .trim(' ', ',', '.', '-', ';', '+')
            .replaceFirstChar { it.uppercaseChar() }
            .ifEmpty { null }
    }

    private fun IntRange.overlaps(other: IntRange) = first <= other.last && other.first <= last
}
