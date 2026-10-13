package com.djtech.monai.feature.categories.presentation.categories.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryKind
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryRow

fun Category.toRow(isBusy: Boolean = false): CategoryRow = CategoryRow(
    id = id,
    name = name,
    icon = icon,
    color = color,
    kind = when {
        isSystem -> CategoryKind.SYSTEM
        isDefault -> CategoryKind.DEFAULT
        else -> CategoryKind.CUSTOM
    },
    isHidden = isHidden,
    isBusy = isBusy,
)

/** By name, with the system category ("Other") last, as the pickers show them. */
fun List<Category>.sortedForList(): List<Category> =
    sortedWith(compareBy(Category::isSystem, { it.name.lowercase() }))

fun CategoryError.message(): UiText = UiText.Resource(
    when (this) {
        CategoryError.Network -> R.string.categories_error_network
        CategoryError.Locked -> R.string.categories_error_locked
        CategoryError.NotFound -> R.string.categories_error_not_found
        is CategoryError.InvalidName, CategoryError.HasTransactions, CategoryError.Unexpected ->
            R.string.categories_error_unexpected
    },
)
