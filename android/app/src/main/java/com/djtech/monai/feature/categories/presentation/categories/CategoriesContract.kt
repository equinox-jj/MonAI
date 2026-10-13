package com.djtech.monai.feature.categories.presentation.categories

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryDeletion
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryRow

/**
 * @param isLoading nothing is cached yet and the first load is running.
 * @param loadError nothing is cached and the load failed.
 * @param rows the [type]'s categories, hidden ones included.
 * @param deletion the delete confirmation or move sheet on screen.
 */
@Immutable
data class CategoriesState(
    val type: CategoryType = CategoryType.EXPENSE,
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val rows: List<CategoryRow> = emptyList(),
    val deletion: CategoryDeletion? = null,
)

sealed interface CategoriesIntent {
    data class SelectType(val type: CategoryType) : CategoriesIntent

    data object Retry : CategoriesIntent

    data object Back : CategoriesIntent

    data object Add : CategoriesIntent

    data class Edit(val id: String) : CategoriesIntent

    data class SetHidden(val id: String, val hidden: Boolean) : CategoriesIntent

    /** Asks to confirm first. */
    data class Delete(val id: String) : CategoriesIntent

    data object ConfirmDelete : CategoriesIntent

    data class PickTarget(val id: String) : CategoriesIntent

    data object DismissDelete : CategoriesIntent
}

sealed interface CategoriesEffect {
    data object Close : CategoriesEffect

    data class Navigate(val destination: CategoriesDestination) : CategoriesEffect

    data class ShowMessage(val message: UiText) : CategoriesEffect
}

sealed interface CategoriesDestination {
    data class New(val type: CategoryType) : CategoriesDestination

    data class Edit(val type: CategoryType, val id: String) : CategoriesDestination
}
