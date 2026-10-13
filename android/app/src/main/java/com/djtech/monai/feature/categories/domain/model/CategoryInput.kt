package com.djtech.monai.feature.categories.domain.model

import com.djtech.monai.core.model.CategoryType

/** A custom category to create. [icon] is a Material Symbols name, [color] `#RRGGBB`. */
data class CategoryInput(
    val name: String,
    val type: CategoryType,
    val icon: String?,
    val color: String?,
)
