package com.djtech.monai.feature.categories.presentation.categoryform

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.validation.MAX_CATEGORY_NAME_LENGTH
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice

/**
 * A new custom category of [type].
 *
 * @param nameError why the name was refused; cleared on the next edit.
 */
@Immutable
data class CategoryFormState(
    val type: CategoryType,
    val name: String = "",
    val icon: CategoryIconChoice = CategoryIconChoice.entries.first(),
    val color: CategoryColorChoice = CategoryColorChoice.entries.first(),
    val nameError: UiText? = null,
    val isSaving: Boolean = false,
) {
    val canSave: Boolean get() = name.isNotBlank() && !isSaving
    val maxNameLength: Int get() = MAX_CATEGORY_NAME_LENGTH
}

sealed interface CategoryFormIntent {
    data class NameChanged(val name: String) : CategoryFormIntent

    data class PickIcon(val icon: CategoryIconChoice) : CategoryFormIntent

    data class PickColor(val color: CategoryColorChoice) : CategoryFormIntent

    data object Save : CategoryFormIntent

    data object Close : CategoryFormIntent
}

sealed interface CategoryFormEffect {
    /** Created, or left without saving: close the form. */
    data object Close : CategoryFormEffect

    data class ShowMessage(val message: UiText) : CategoryFormEffect
}
