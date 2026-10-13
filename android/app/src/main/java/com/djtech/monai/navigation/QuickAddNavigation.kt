package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.TransactionDraft

/** One draft opens the add form filled with it. */
internal fun MainNavigator.openDraftForm(draft: TransactionDraft) {
    navigate(TransactionFormRoute(draft = draft.toKey()))
}

internal fun MainNavigator.openDraftReview(phrase: String, drafts: List<TransactionDraft>) {
    navigate(QuickAddReviewRoute(phrase, drafts.map { it.toKey() }))
}

/** After a draft is saved, or "Back to home": closes quick add and what it opened. */
internal fun MainNavigator.closeQuickAdd() {
    popWhile { it.isQuickAddStep() }
}

private fun NavKey.isQuickAddStep(): Boolean =
    this == QuickAddRoute || this is QuickAddReviewRoute || (this is TransactionFormRoute && draft != null)
