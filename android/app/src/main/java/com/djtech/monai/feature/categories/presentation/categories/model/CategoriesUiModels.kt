package com.djtech.monai.feature.categories.presentation.categories.model

import androidx.compose.runtime.Immutable

/** What a category may do, which decides its tag, its note and its action. */
enum class CategoryKind {
    /** Shipped with the account: can be hidden, not deleted. */
    DEFAULT,

    /** Made by the user: can be deleted. */
    CUSTOM,

    /** "Other": never hidden or deleted, so every transaction has a category. */
    SYSTEM,
}

/** One row of the list. [icon] is a Material Symbols name and [color] `#RRGGBB`, as the API stores them. */
@Immutable
data class CategoryRow(
    val id: String,
    val name: String,
    val icon: String?,
    val color: String?,
    val kind: CategoryKind,
    val isHidden: Boolean,
    /** A hide or show request for it is running. */
    val isBusy: Boolean = false,
) {
    val canHide: Boolean get() = kind == CategoryKind.DEFAULT || (kind == CategoryKind.CUSTOM && isHidden)
    val canDelete: Boolean get() = kind == CategoryKind.CUSTOM
    val canEdit: Boolean get() = kind != CategoryKind.SYSTEM
}

/**
 * Deleting [category]: first a plain confirmation; if it turns out to have transactions,
 * [targets] (the other categories of its type) to move them to, [targetId] picked.
 */
@Immutable
data class CategoryDeletion(
    val category: CategoryRow,
    val needsTarget: Boolean = false,
    val targets: List<CategoryRow> = emptyList(),
    val targetId: String? = null,
    val isDeleting: Boolean = false,
)
