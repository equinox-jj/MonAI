package com.djtech.monai.feature.receipt.presentation.receiptreview

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.receipt.presentation.receiptreview.model.ReceiptSheet
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.LocalDate
import java.time.YearMonth

/**
 * A receipt's draft, ready to check and save with its photo.
 *
 * @param aiFailed the AI couldn't read the receipt, so the fields start empty.
 * @param merchantFromAi the merchant came from the receipt and hasn't been edited.
 * @param uploadProgress 0..1 while the photo uploads on save; null otherwise.
 */
@Immutable
data class ReceiptReviewState(
    val today: LocalDate,
    val photoUri: String,
    val aiFailed: Boolean = false,
    val type: TransactionType = TransactionType.EXPENSE,
    val amount: Long? = null,
    val merchant: String = "",
    val merchantFromAi: Boolean = false,
    val note: String = "",
    val category: Category? = null,
    val walletId: String? = null,
    val walletName: String? = null,
    val date: LocalDate = today,
    val items: List<ReceiptItem> = emptyList(),
    val highlights: Map<TransactionField, FieldHighlight> = emptyMap(),
    val categories: List<Category> = emptyList(),
    val wallets: List<Wallet> = emptyList(),
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: ReceiptSheet? = null,
    val isSaving: Boolean = false,
    val uploadProgress: Float? = null,
)

sealed interface ReceiptReviewIntent {
    /** Expense or income; a receipt is never a transfer. */
    data class SelectType(val type: TransactionType) : ReceiptReviewIntent

    data object OpenAmount : ReceiptReviewIntent

    data object OpenCategory : ReceiptReviewIntent

    data object OpenWallet : ReceiptReviewIntent

    data object OpenDate : ReceiptReviewIntent

    data class SheetAmount(val amount: Long) : ReceiptReviewIntent

    data class SheetPickCategory(val id: String) : ReceiptReviewIntent

    data class SheetPickWallet(val id: String) : ReceiptReviewIntent

    data class SheetPickDate(val date: LocalDate) : ReceiptReviewIntent

    data class SheetShowMonth(val month: YearMonth) : ReceiptReviewIntent

    data object ConfirmSheet : ReceiptReviewIntent

    data object DismissSheet : ReceiptReviewIntent

    data class MerchantChanged(val merchant: String) : ReceiptReviewIntent

    data class NoteChanged(val note: String) : ReceiptReviewIntent

    data object Save : ReceiptReviewIntent

    data object Retake : ReceiptReviewIntent

    data object Back : ReceiptReviewIntent
}

sealed interface ReceiptReviewEffect {
    /** Saved with its photo as transaction [id]. */
    data class Saved(val id: String) : ReceiptReviewEffect

    data object Retake : ReceiptReviewEffect

    data object Back : ReceiptReviewEffect

    data class ShowMessage(val message: UiText) : ReceiptReviewEffect
}
