package com.djtech.monai.feature.categories.domain.validation

import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue

/** The API's limit on category names. */
const val MAX_CATEGORY_NAME_LENGTH = 30

/** Trims the name, so the form never sends surrounding whitespace. */
fun CategoryInput.normalized(): CategoryInput = copy(name = name.trim())

/** The API's name rules, checked on the device; null when the name is fine. */
fun CategoryInput.nameIssue(): CategoryNameIssue? = when {
    name.isBlank() -> CategoryNameIssue.REQUIRED
    name.length > MAX_CATEGORY_NAME_LENGTH -> CategoryNameIssue.TOO_LONG
    else -> null
}
