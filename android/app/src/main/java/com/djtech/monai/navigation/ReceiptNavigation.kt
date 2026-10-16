package com.djtech.monai.navigation

import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.feature.receipt.presentation.receiptreview.ReceiptReviewRoute
import com.djtech.monai.feature.receipt.presentation.scanreceipt.ScanReceiptRoute

internal fun MainNavigator.openReceiptReview(photoUri: String, draft: ReceiptDraft, aiFailed: Boolean) {
    navigate(ReceiptReviewRoute(photoUri, draft.toKey(), aiFailed))
}

/** "Type instead": back to the add form the scan was opened from, else a new one in its place. */
internal fun MainNavigator.typeInsteadOfScan() {
    popWhile { it == ScanReceiptRoute }
    if (backStack.lastOrNull()?.isBlankAddForm() != true) navigate(TransactionFormRoute())
}

/** After a receipt is saved: closes the scan, its review and the add form it came from, then shows it. */
internal fun MainNavigator.showSavedReceipt(transactionId: String) {
    popWhile { it == ScanReceiptRoute || it is ReceiptReviewRoute || it.isBlankAddForm() }
    navigate(TransactionDetailRoute(transactionId))
}

private fun NavKey.isBlankAddForm(): Boolean = this is TransactionFormRoute && id == null && draft == null

/** Receipt scanning and the review of what it read. */
internal fun EntryProviderScope<NavKey>.receiptEntries(navigator: MainNavigator) {
    entry<ScanReceiptRoute> {
        ScanReceiptRoute(
            onClose = navigator::goBack,
            onOpenReview = navigator::openReceiptReview,
            onOpenForm = navigator::typeInsteadOfScan,
        )
    }
    entry<ReceiptReviewRoute> { key ->
        ReceiptReviewRoute(
            photoUri = key.photoUri,
            receipt = key.draft.toModel(),
            aiFailed = key.aiFailed,
            onBack = navigator::goBack,
            onRetake = navigator::goBack,
            onSaved = navigator::showSavedReceipt,
        )
    }
}
