package com.djtech.monai.feature.budgets.presentation.budget

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.budgets.domain.model.BudgetPreview
import java.time.YearMonth

/**
 * @param limit the limit being typed, rupiah; starts at the saved one. 0 while empty.
 * @param spent rupiah spent in [month]: the budget's figure, or the month report's while none is set.
 * @param hasBudget [month] has a saved budget, so it can be removed.
 * @param limitError why the typed limit was refused.
 */
@Immutable
data class BudgetState(
    val month: YearMonth,
    val limit: Long = 0,
    val spent: Long = 0,
    val hasBudget: Boolean = false,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val limitError: UiText? = null,
    val isConfirmingDelete: Boolean = false,
) {
    /** How [spent] compares with the typed limit; null while it is empty. */
    val preview: BudgetPreview? get() = BudgetPreview.of(spent, limit)

    val isWorking: Boolean get() = isSaving || isDeleting

    val canSave: Boolean get() = limit > 0 && !isWorking
}

sealed interface BudgetIntent {
    /** [limit] is rupiah; 0 when the field is cleared. */
    data class LimitChanged(val limit: Long) : BudgetIntent

    data class PickPreset(val limit: Long) : BudgetIntent

    data object Save : BudgetIntent

    /** Asks to confirm first. */
    data object Delete : BudgetIntent

    data object ConfirmDelete : BudgetIntent

    data object DismissDelete : BudgetIntent

    data object Back : BudgetIntent
}

sealed interface BudgetEffect {
    /** Saved, removed or left: close the screen. */
    data object Close : BudgetEffect

    data class ShowMessage(val message: UiText) : BudgetEffect
}
