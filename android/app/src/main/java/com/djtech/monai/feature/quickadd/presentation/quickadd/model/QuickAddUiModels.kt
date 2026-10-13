package com.djtech.monai.feature.quickadd.presentation.quickadd.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.TransactionType
import java.time.LocalDate

/** What a chip under the input says was understood. */
enum class ChipKind { AMOUNT, CATEGORY, WALLET, DATE }

/**
 * One understood piece of the phrase. [unsure] chips ("Amount?", "Wallet?") are amber. [name] is a
 * category or wallet name, [amount] and [date] fill the other kinds; a missing value shows as "?".
 */
@Immutable
data class QuickAddChip(
    val kind: ChipKind,
    val unsure: Boolean,
    val name: String? = null,
    val amount: Long? = null,
    val date: LocalDate? = null,
)

/** A draft as a row: category icon, title (note, else category), meta line and amount. */
@Immutable
data class QuickAddDraftRow(
    val type: TransactionType,
    val amount: Long?,
    val title: String?,
    val categoryName: String?,
    val categoryIcon: String?,
    val categoryColor: String?,
    val walletName: String?,
    /** No wallet was named, so the default one is used. */
    val walletIsDefault: Boolean,
    val toWalletName: String?,
    val date: LocalDate,
)

/** The line under the input: who read the phrase, or which guess to check. */
sealed interface EngineNote {
    /** Understood on the phone; nothing sent to the AI. */
    data object OnPhone : EngineNote

    /** No wallet named; [walletName] (the default) is used. */
    data class DefaultWallet(val walletName: String) : EngineNote

    /** The phone couldn't fill everything; Continue will ask the AI. */
    data object WillAskAi : EngineNote

    data object AskedAi : EngineNote
}
