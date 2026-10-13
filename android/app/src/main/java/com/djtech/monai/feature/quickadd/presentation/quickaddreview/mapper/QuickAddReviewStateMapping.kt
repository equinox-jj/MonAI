package com.djtech.monai.feature.quickadd.presentation.quickaddreview.mapper

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSummaryRow
import com.djtech.monai.feature.transactions.presentation.transactionform.mapper.toHighlights
import java.time.LocalDate

/** A draft to review: missing type and date become an expense today, and a future date becomes today. */
fun TransactionDraft.toReviewDraft(today: LocalDate): ReviewDraft = ReviewDraft(
    type = type ?: TransactionType.EXPENSE,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date?.takeIf { !it.isAfter(today) } ?: today,
    note = note.orEmpty(),
    highlights = toHighlights(),
)

fun ReviewDraft.toSummaryRow(
    outcome: ReviewOutcome,
    categories: List<Category>,
    wallets: List<Wallet>,
): ReviewSummaryRow {
    val category = categories.find { it.id == categoryId }
    return ReviewSummaryRow(
        outcome = outcome,
        type = type,
        amount = amount,
        title = note.ifBlank { category?.name.orEmpty() },
        category = category,
        walletName = wallets.find { it.id == walletId }?.name,
        date = date,
    )
}
