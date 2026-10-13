package com.djtech.monai.feature.categories.domain.model

/** Why a category action failed, in terms the category screens can show. */
sealed interface CategoryError {
    data object Network : CategoryError

    /** The device or the server rejected the name. */
    data class InvalidName(val issue: CategoryNameIssue) : CategoryError

    data object Unexpected : CategoryError
}

/** What is wrong with a category name. */
enum class CategoryNameIssue {
    /** Missing or blank. */
    REQUIRED,

    /** Over 30 characters. */
    TOO_LONG,

    /** Another category already has this name. */
    ALREADY_EXISTS,

    /** A code this app does not know yet; show a generic message. */
    INVALID,
}
