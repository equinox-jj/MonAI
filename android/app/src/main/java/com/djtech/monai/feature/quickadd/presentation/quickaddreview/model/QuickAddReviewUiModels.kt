package com.djtech.monai.feature.quickadd.presentation.quickaddreview.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.LocalDate
import java.time.YearMonth

/** A draft being reviewed, as the user has edited it so far. */
@Immutable
data class ReviewDraft(
    val type: TransactionType,
    val amount: Long?,
    val walletId: String?,
    val toWalletId: String?,
    val categoryId: String?,
    val date: LocalDate,
    val note: String,
    val highlights: Map<TransactionField, FieldHighlight>,
)

/** What happened to each draft once passed. */
enum class ReviewOutcome { SAVED, SKIPPED }

/** One line of the summary after the last draft. */
@Immutable
data class ReviewSummaryRow(
    val outcome: ReviewOutcome,
    val type: TransactionType,
    val amount: Long?,
    val title: String,
    val category: Category?,
    val walletName: String?,
    val date: LocalDate,
)

/** Which side of a transfer a wallet picker sets. */
enum class ReviewWalletTarget { SOURCE, DESTINATION }

/** An open picker; its choice applies on confirm. */
@Immutable
sealed interface ReviewSheet {
    data class Category(val selectedId: String?) : ReviewSheet

    data class Wallet(val target: ReviewWalletTarget, val selectedId: String?) : ReviewSheet

    data class Date(val selected: LocalDate, val shownMonth: YearMonth) : ReviewSheet

    data class Amount(val amount: Long) : ReviewSheet
}
