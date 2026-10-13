package com.djtech.monai.feature.quickadd.presentation.quickaddreview

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSheet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSummaryRow
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.LocalDate
import java.time.YearMonth

/**
 * Several quick-add drafts, reviewed one at a time: save or skip each, then a summary.
 *
 * @param index the draft on screen; equal to [total] once every draft is passed.
 * @param draft the draft on screen, null on the summary.
 * @param categories the visible categories of the draft's type, for the picker.
 * @param wallets wallets that are not archived, for the pickers.
 */
@Immutable
data class QuickAddReviewState(
    val today: LocalDate,
    val phrase: String,
    val total: Int,
    val index: Int = 0,
    val draft: ReviewDraft? = null,
    val category: Category? = null,
    val walletName: String? = null,
    val toWalletName: String? = null,
    val categories: List<Category> = emptyList(),
    val wallets: List<Wallet> = emptyList(),
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: ReviewSheet? = null,
    val isSaving: Boolean = false,
    val summary: List<ReviewSummaryRow> = emptyList(),
) {
    val isDone: Boolean get() = index >= total
    val isLast: Boolean get() = index == total - 1
    val savedCount: Int get() = summary.count { it.outcome == ReviewOutcome.SAVED }
}

sealed interface QuickAddReviewIntent {
    data object OpenAmount : QuickAddReviewIntent

    data object OpenCategory : QuickAddReviewIntent

    data class OpenWallet(val target: ReviewWalletTarget) : QuickAddReviewIntent

    data object OpenDate : QuickAddReviewIntent

    data class SheetAmount(val amount: Long) : QuickAddReviewIntent

    data class SheetPickCategory(val id: String) : QuickAddReviewIntent

    data class SheetPickWallet(val id: String) : QuickAddReviewIntent

    data class SheetPickDate(val date: LocalDate) : QuickAddReviewIntent

    data class SheetShowMonth(val month: YearMonth) : QuickAddReviewIntent

    data object ConfirmSheet : QuickAddReviewIntent

    data object DismissSheet : QuickAddReviewIntent

    data class NoteChanged(val note: String) : QuickAddReviewIntent

    /** Save this draft, then show the next one or the summary. */
    data object Save : QuickAddReviewIntent

    data object Skip : QuickAddReviewIntent

    /** Back, or "Start over" on the summary: back to quick add. */
    data object Back : QuickAddReviewIntent

    /** "Back to home" on the summary. */
    data object Finish : QuickAddReviewIntent
}

sealed interface QuickAddReviewEffect {
    data object Back : QuickAddReviewEffect

    data object Finish : QuickAddReviewEffect

    data class ShowMessage(val message: UiText) : QuickAddReviewEffect
}
