package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.ReceiptDraft

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
