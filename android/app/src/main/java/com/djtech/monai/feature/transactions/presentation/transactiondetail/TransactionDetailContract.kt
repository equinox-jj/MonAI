package com.djtech.monai.feature.transactions.presentation.transactiondetail

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.LocalDate

/**
 * @param transaction null until it is cached; then [isLoading] or [loadError] says why.
 * @param loadError the fetch failed with nothing cached, or the transaction no longer exists.
 * @param isReceiptOpen the receipt photo is shown full screen.
 * @param isPhotoSourceOpen the camera-or-gallery sheet for adding or replacing the receipt is open.
 * @param receiptUpload 0..1 while a new receipt photo uploads; null otherwise.
 */
@Immutable
data class TransactionDetailState(
    val today: LocalDate,
    val transaction: Transaction? = null,
    val lookups: TransactionLookups = TransactionLookups(),
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val isDeleting: Boolean = false,
    val isReceiptOpen: Boolean = false,
    val isPhotoSourceOpen: Boolean = false,
    val receiptUpload: Float? = null,
)

sealed interface TransactionDetailIntent {
    data object Back : TransactionDetailIntent

    data object Edit : TransactionDetailIntent

    /** Deletes at once; the undo message comes from the app shell. */
    data object Delete : TransactionDetailIntent

    data object Retry : TransactionDetailIntent

    data object OpenReceipt : TransactionDetailIntent

    data object CloseReceipt : TransactionDetailIntent

    /** "Add" or "Replace" on the receipt card: asks camera or gallery. */
    data object AddReceipt : TransactionDetailIntent

    data object TakeReceiptPhoto : TransactionDetailIntent

    data object ChooseReceiptPhoto : TransactionDetailIntent

    data object DismissPhotoSource : TransactionDetailIntent

    /** The camera's or gallery's answer; null when cancelled. */
    data class ReceiptPhotoPicked(val uri: String?) : TransactionDetailIntent
}

sealed interface TransactionDetailEffect {
    data object NavigateBack : TransactionDetailEffect

    data class OpenEdit(val id: String) : TransactionDetailEffect

    data class ShowMessage(val message: UiText) : TransactionDetailEffect

    /** Opens the camera app to save a photo to [uri]. */
    data class LaunchCamera(val uri: String) : TransactionDetailEffect

    data object LaunchGallery : TransactionDetailEffect
}
