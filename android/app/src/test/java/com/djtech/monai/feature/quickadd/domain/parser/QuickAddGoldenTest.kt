package com.djtech.monai.feature.quickadd.domain.parser

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.quickadd.domain.model.needsAi
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDate

/**
 * The PRD's golden test set for layer 1: every phrase in `golden/quick_add_phrases.json` is
 * parsed on the "phone" and scored per field. A phrase is handled locally when quick add would
 * not call the AI for it and every field came out right; the PRD asks for 80% or more.
 * "Sure but wrong" counts fields the parser got wrong without flagging them (confidence ≥ 0.7),
 * which the user would not be asked to check.
 */
class QuickAddGoldenTest {

    private val golden: GoldenSet = Json.decodeFromString(
        checkNotNull(javaClass.getResourceAsStream("/golden/quick_add_phrases.json")) {
            "golden/quick_add_phrases.json is missing from test resources"
        }.bufferedReader().readText(),
    )

    private val context: ParseContext = golden.toContext()

    @Test
    fun `layer 1 handles at least 80 percent of the golden phrases on its own`() {
        val results = golden.phrases.map { score(it) }
        val handled = results.count { it.handledLocally }
        val fieldChecks = results.flatMap { it.checks }
        val sureButWrong = fieldChecks.count { !it.correct && it.sure }

        println(report(results))

        val handledRate = handled.toDouble() / results.size
        assertTrue("handled locally: ${percent(handledRate)}, PRD target 80%", handledRate >= HANDLED_TARGET)
        val sureButWrongRate = sureButWrong.toDouble() / fieldChecks.size
        assertTrue(
            "sure but wrong: ${percent(sureButWrongRate)} of fields, at most ${percent(SURE_BUT_WRONG_LIMIT)}",
            sureButWrongRate <= SURE_BUT_WRONG_LIMIT,
        )
    }

    private fun score(phrase: GoldenPhrase): PhraseResult {
        val drafts = QuickAddParser.parse(phrase.text, context)
        val checks = if (drafts.size == phrase.drafts.size) {
            phrase.drafts.zip(drafts).flatMap { (expected, actual) -> checkFields(expected, actual) }
        } else {
            // A wrong number of drafts fails every expected field.
            phrase.drafts.flatMap { expected -> FIELDS.map { FieldCheck(it, correct = false, sure = false) } }
        }
        return PhraseResult(
            text = phrase.text,
            checks = checks,
            draftCountRight = drafts.size == phrase.drafts.size,
            needsAi = drafts.needsAi(),
        )
    }

    private fun checkFields(expected: GoldenDraft, actual: TransactionDraft): List<FieldCheck> {
        val confidence = actual.confidence
        val isTransfer = expected.type == TransactionType.TRANSFER
        return listOf(
            FieldCheck("type", actual.type == expected.type, confidence.type >= SURE),
            FieldCheck("amount", actual.amount == expected.amount, confidence.amount >= SURE),
            FieldCheck("wallet", walletName(actual.walletId) == expected.wallet, confidence.wallet >= SURE),
            if (isTransfer) {
                FieldCheck("category", walletName(actual.toWalletId) == expected.toWallet, confidence.wallet >= SURE)
            } else {
                FieldCheck(
                    "category",
                    categoryName(actual.categoryId) == expected.category,
                    confidence.category >= SURE,
                )
            },
            FieldCheck("date", actual.date == LocalDate.parse(expected.date), confidence.date >= SURE),
        )
    }

    private fun walletName(id: String?) = context.wallets.find { it.id == id }?.name

    private fun categoryName(id: String?) = context.categories.find { it.id == id }?.name

    private fun report(results: List<PhraseResult>): String = buildString {
        val checks = results.flatMap { it.checks }
        appendLine("Quick-add golden set, layer 1 (${results.size} phrases)")
        appendLine("  handled locally: ${percent(results.count { it.handledLocally }, results.size)}")
        appendLine("  draft count right: ${percent(results.count { it.draftCountRight }, results.size)}")
        FIELDS.forEach { field ->
            val forField = checks.filter { it.field == field }
            appendLine("  $field: ${percent(forField.count { it.correct }, forField.size)}")
        }
        appendLine("  sure but wrong: ${checks.count { !it.correct && it.sure }} of ${checks.size} fields")
        results.filterNot { it.handledLocally }.forEach { result ->
            val wrong =
                result.checks.filterNot { it.correct }.joinToString { it.field + if (it.sure) " (sure)" else "" }
            val why = when {
                !result.draftCountRight -> "wrong number of drafts"
                wrong.isNotEmpty() -> "wrong: $wrong"
                else -> "right, but unsure, so the AI is asked"
            }
            appendLine("  - \"${result.text}\": $why")
        }
    }

    private class FieldCheck(val field: String, val correct: Boolean, val sure: Boolean)

    private class PhraseResult(
        val text: String,
        val checks: List<FieldCheck>,
        val draftCountRight: Boolean,
        val needsAi: Boolean,
    ) {
        val handledLocally: Boolean get() = draftCountRight && !needsAi && checks.all { it.correct }
    }

    private companion object {
        const val HANDLED_TARGET = 0.8
        const val SURE_BUT_WRONG_LIMIT = 0.05
        const val SURE = 0.7

        // Transfers score their destination wallet under "category".
        val FIELDS = listOf("type", "amount", "wallet", "category", "date")

        fun percent(rate: Double) = "%.0f%%".format(rate * 100)

        fun percent(count: Int, total: Int) = "$count/$total (${percent(count.toDouble() / total)})"
    }
}

@Serializable
private data class GoldenSet(
    val description: String,
    val today: String,
    val wallets: List<GoldenWallet>,
    val categories: List<GoldenCategory>,
    val phrases: List<GoldenPhrase>,
) {
    /** Wallets and categories get their names as ids; each wallet with aliases gets a provider. */
    fun toContext(): ParseContext {
        val providers = wallets.filter { it.aliases.isNotEmpty() }.map {
            paymentProvider(it.name.lowercase(), name = it.name, type = it.type).copy(aliases = it.aliases)
        }
        return ParseContext(
            wallets = wallets.map {
                wallet(
                    it.name,
                    name = it.name,
                    isDefault = it.isDefault,
                    type = it.type,
                    providerId = providers.find { p -> p.name == it.name }?.id,
                )
            },
            categories = categories.map { category(it.name, name = it.name, type = it.type, isSystem = it.isSystem) },
            providers = providers,
            today = LocalDate.parse(today),
        )
    }
}

@Serializable
private data class GoldenWallet(
    val name: String,
    val type: WalletType,
    val isDefault: Boolean = false,
    val aliases: List<String> = emptyList(),
)

@Serializable
private data class GoldenCategory(val name: String, val type: CategoryType, val isSystem: Boolean = false)

@Serializable
private data class GoldenPhrase(val text: String, val drafts: List<GoldenDraft>)

/** One expected draft. [amount] null means the phrase has none; [toWallet] is for transfers only. */
@Serializable
private data class GoldenDraft(
    val type: TransactionType,
    val amount: Long?,
    val wallet: String,
    val category: String? = null,
    val toWallet: String? = null,
    val date: String,
)
