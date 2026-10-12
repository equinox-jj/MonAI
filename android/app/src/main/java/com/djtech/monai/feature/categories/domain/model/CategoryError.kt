package com.djtech.monai.feature.categories.domain.model

/** Why a category action failed, in terms the category screens can show. */
sealed interface CategoryError {
    data object Network : CategoryError

    data object Unexpected : CategoryError
}
