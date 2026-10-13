package com.djtech.monai.feature.wallets.presentation.walletdetail.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.TransactionType
import java.time.LocalDate

/** One bar of the "Money out" chart: what left the wallet that day, in rupiah. */
@Immutable
data class OutflowDay(val date: LocalDate, val amount: Long)

/** What the transaction rows need to name categories and the other wallet of a transfer. */
@Immutable
data class WalletRowLookups(
    val categories: Map<String, Category> = emptyMap(),
    val walletNames: Map<String, String> = emptyMap(),
)

/** Whether a transaction added money to the wallet or took it out, from the wallet's side. */
enum class RowFlow { IN, OUT }

/**
 * A transaction as the wallet sees it.
 *
 * @param title the note, else the merchant, else the category name.
 * @param label the category, or which wallet a transfer went to or came from.
 */
@Immutable
data class WalletTransactionRow(
    val id: String,
    val type: TransactionType,
    /** Rupiah, positive; [flow] gives the sign. */
    val amount: Long,
    val flow: RowFlow,
    val title: UiText,
    val label: UiText,
    val date: LocalDate,
    val icon: String?,
    /** `#RRGGBB`. */
    val color: String?,
)

sealed interface WalletDetailDialog {
    data object ConfirmDelete : WalletDetailDialog

    /** Delete was refused because the wallet has transactions. */
    data object ArchiveInstead : WalletDetailDialog
}
