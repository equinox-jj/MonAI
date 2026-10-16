package com.djtech.monai.navigation

import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.presentation.quickadd.QuickAddRoute
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.QuickAddReviewRoute

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

/** Quick add and its review of several drafts; both are side sheets on a wide screen. */
internal fun EntryProviderScope<NavKey>.quickAddEntries(navigator: MainNavigator, config: MainNavConfig) {
    formEntry<QuickAddRoute>(config) { _, modifier, placement ->
        QuickAddRoute(
            onClose = navigator::goBack,
            onOpenForm = navigator::openDraftForm,
            onOpenReview = navigator::openDraftReview,
            modifier = modifier,
            placement = placement,
        )
    }
    formEntry<QuickAddReviewRoute>(config) { key, modifier, placement ->
        QuickAddReviewRoute(
            phrase = key.phrase,
            drafts = key.drafts.map { it.toModel() },
            onBack = navigator::goBack,
            onFinish = navigator::closeQuickAdd,
            modifier = modifier,
            placement = placement,
        )
    }
}
