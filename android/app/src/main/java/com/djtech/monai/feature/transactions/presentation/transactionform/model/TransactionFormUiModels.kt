package com.djtech.monai.feature.transactions.presentation.transactionform.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.TransactionType
import java.time.LocalDate
import java.time.YearMonth

sealed interface TransactionFormMode {
    data object Add : TransactionFormMode

    data class Edit(val id: String) : TransactionFormMode
}

/**
 * How a new transaction starts, e.g. a transfer out of the wallet whose detail screen opened the form.
 * A null [walletId] starts from the default wallet. Ignored when editing.
 */
data class TransactionFormPreset(
    val type: TransactionType = TransactionType.EXPENSE,
    val walletId: String? = null,
)

/** Which wallet a wallet picker sets: the source (or the only wallet), or a transfer's destination. */
enum class WalletTarget { SOURCE, DESTINATION }

/** An open picker sheet and the choice made in it, not applied until confirmed. */
@Immutable
sealed interface FormSheet {
    data class Category(val selectedId: String?) : FormSheet

    data class Wallet(val target: WalletTarget, val selectedId: String?) : FormSheet

    /** [shownMonth] is the calendar page; it can't go past the month of today. */
    data class Date(val selected: LocalDate, val shownMonth: YearMonth) : FormSheet
}
