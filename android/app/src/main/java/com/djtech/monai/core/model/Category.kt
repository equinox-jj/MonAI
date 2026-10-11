package com.djtech.monai.core.model

import java.time.Instant

enum class CategoryType { EXPENSE, INCOME }

data class Category(
    val id: String,
    val name: String,
    val type: CategoryType,
    val icon: String?,
    /** `#RRGGBB`. */
    val color: String?,
    /** Created on register; can be hidden, not deleted. */
    val isDefault: Boolean,
    /** "Other" and "Other Income"; can be neither hidden nor deleted. */
    val isSystem: Boolean,
    /** Hidden from pickers. */
    val isHidden: Boolean,
    val createdAt: Instant,
    val updatedAt: Instant,
)
