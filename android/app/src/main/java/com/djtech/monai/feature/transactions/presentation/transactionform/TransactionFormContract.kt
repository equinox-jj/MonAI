package com.djtech.monai.feature.transactions.presentation.transactionform

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormMode
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget
import java.time.LocalDate
import java.time.YearMonth

/**
 * The add and edit form.
 *
 * @param isLoading editing, and the transaction isn't loaded yet.
 * @param loadError editing, and the transaction couldn't be loaded.
 * @param amount rupiah typed on the keypad.
 * @param originalAmount the saved amount while editing, shown as "Was Rp 35.000" once it changes.
 * @param categories the visible categories of [type], for the chips and the picker.
 * @param wallets wallets that are not archived, for the pickers.
 * @param lookups names of every wallet and category, archived and hidden ones included.
 * @param errors one message per invalid field, from the device's checks or the server's.
 */
@Immutable
data class TransactionFormState(
    val mode: TransactionFormMode,
    val today: LocalDate,
    val date: LocalDate = today,
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val type: TransactionType = TransactionType.EXPENSE,
    val amount: Long = 0,
    val originalAmount: Long? = null,
    val walletId: String? = null,
    val toWalletId: String? = null,
    val categoryId: String? = null,
    val note: String = "",
    val categories: List<Category> = emptyList(),
    val wallets: List<Wallet> = emptyList(),
    val lookups: TransactionLookups = TransactionLookups(),
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: FormSheet? = null,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val showDiscardDialog: Boolean = false,
) {
    val isEdit: Boolean get() = mode is TransactionFormMode.Edit
    val currentMonth: YearMonth get() = YearMonth.from(today)
}

sealed interface TransactionFormIntent {
    data class SelectType(val type: TransactionType) : TransactionFormIntent

    data class Digit(val digit: Int) : TransactionFormIntent

    /** The keypad's "000" key. */
    data object TripleZero : TransactionFormIntent

    data object Backspace : TransactionFormIntent

    /** A category chip on the add form: picks it at once. */
    data class PickCategory(val id: String) : TransactionFormIntent

    data class NoteChanged(val note: String) : TransactionFormIntent

    data object OpenCategoryPicker : TransactionFormIntent

    data class OpenWalletPicker(val target: WalletTarget) : TransactionFormIntent

    data object OpenDatePicker : TransactionFormIntent

    data class SheetPickCategory(val id: String) : TransactionFormIntent

    /** The category picker's "New" tile: creates a category of the form's type, then selects it. */
    data object NewCategory : TransactionFormIntent

    data class SheetPickWallet(val id: String) : TransactionFormIntent

    data class SheetPickDate(val date: LocalDate) : TransactionFormIntent

    data class SheetShowMonth(val month: YearMonth) : TransactionFormIntent

    data object ConfirmSheet : TransactionFormIntent

    data object DismissSheet : TransactionFormIntent

    data object Save : TransactionFormIntent

    /** Close or back: asks first when something was changed. */
    data object Close : TransactionFormIntent

    data object ConfirmDiscard : TransactionFormIntent

    data object KeepEditing : TransactionFormIntent

    /** Editing only; the undo message comes from the app shell. */
    data object Delete : TransactionFormIntent

    data object Retry : TransactionFormIntent
}

sealed interface TransactionFormEffect {
    /** Saved, or closed without saving. */
    data object Close : TransactionFormEffect

    /** The edited transaction was deleted, so its detail screen should close too. */
    data class Deleted(val id: String) : TransactionFormEffect

    data class ShowMessage(val message: UiText) : TransactionFormEffect

    /** Opens the category form; the category it creates comes back selected in the picker. */
    data class OpenNewCategory(val type: CategoryType) : TransactionFormEffect
}
