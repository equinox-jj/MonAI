package com.djtech.monai.feature.quickadd.presentation.quickadd.mapper

import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.isLowConfidence
import com.djtech.monai.feature.quickadd.domain.model.DraftEngine
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.ChipKind
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddDraftRow

/** Chips for every draft's amount and category, then the wallets and dates they share, without repeats. */
fun List<TransactionDraft>.toChips(context: ParseContext): List<QuickAddChip> {
    val amounts = map { QuickAddChip(ChipKind.AMOUNT, it.amount == null, amount = it.amount) }
    val categories = filter { it.type != TransactionType.TRANSFER }.map {
        QuickAddChip(
            ChipKind.CATEGORY,
            unsure = it.categoryId == null || it.confidence.category.isLowConfidence(),
            name = context.categoryName(it.categoryId),
        )
    }
    val wallets = map {
        QuickAddChip(
            ChipKind.WALLET,
            unsure = it.walletId == null || it.confidence.wallet.isLowConfidence(),
            // An unsure wallet shows as "Wallet?"; the engine note names the default in use.
            name = if (it.confidence.wallet.isLowConfidence()) null else context.walletName(it.walletId),
        )
    }
    val dates = mapNotNull { draft -> draft.date?.let { QuickAddChip(ChipKind.DATE, false, date = it) } }
    return (amounts + categories + wallets + dates).distinct()
}

fun List<TransactionDraft>.toRows(context: ParseContext): List<QuickAddDraftRow> = map { draft ->
    val category = context.categories.find { it.id == draft.categoryId }
    QuickAddDraftRow(
        type = draft.type ?: TransactionType.EXPENSE,
        amount = draft.amount,
        title = draft.note,
        categoryName = category?.name,
        categoryIcon = category?.icon,
        categoryColor = category?.color,
        walletName = context.walletName(draft.walletId),
        walletIsDefault = draft.confidence.wallet.isLowConfidence() && draft.walletId == context.defaultWalletId,
        toWalletName = context.walletName(draft.toWalletId),
        date = draft.date ?: context.today,
    )
}

/** Says who read the phrase, or which guess the user should know about. */
fun List<TransactionDraft>.toEngineNote(engine: DraftEngine, needsAi: Boolean, context: ParseContext): EngineNote? {
    if (isEmpty()) return null
    return when {
        engine == DraftEngine.AI -> EngineNote.AskedAi
        engine == DraftEngine.LOCAL && needsAi -> EngineNote.WillAskAi
        else -> firstOrNull { it.confidence.wallet.isLowConfidence() }
            ?.let { context.walletName(it.walletId) }
            ?.let(EngineNote::DefaultWallet)
            ?: EngineNote.OnPhone
    }
}

private fun ParseContext.walletName(id: String?): String? = wallets.find { it.id == id }?.name

private fun ParseContext.categoryName(id: String?): String? = categories.find { it.id == id }?.name
