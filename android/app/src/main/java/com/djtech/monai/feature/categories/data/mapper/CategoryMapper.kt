package com.djtech.monai.feature.categories.data.mapper

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.data.dto.CreateCategoryRequestDto
import com.djtech.monai.feature.categories.data.dto.UpdateCategoryRequestDto
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryNameIssue
import java.time.Instant

fun CategoryDto.asModel(): Category = Category(
    id = id,
    name = name,
    type = type,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isSystem = isSystem,
    isHidden = isHidden,
    createdAt = Instant.parse(createdAt),
    updatedAt = Instant.parse(updatedAt),
)

fun CategoryInput.toCreateRequest() = CreateCategoryRequestDto(
    name = name,
    type = type,
    icon = icon,
    color = color,
)

fun CategoryChanges.toUpdateRequest() = UpdateCategoryRequestDto(
    name = name,
    icon = icon,
    color = color,
    isHidden = isHidden,
)

/**
 * Branches on the backend's stable error codes, never on the message. A taken name comes back as a
 * bare `conflict`; other rejected fields (icon, color) are the app's fault, so they are unexpected.
 */
fun ApiError.toCategoryError(): CategoryError = when (this) {
    ApiError.Network -> CategoryError.Network
    is ApiError.Unknown -> CategoryError.Unexpected
    is ApiError.Http -> when (code) {
        "conflict" -> CategoryError.InvalidName(CategoryNameIssue.ALREADY_EXISTS)
        "category_has_transactions" -> CategoryError.HasTransactions
        "system_category_locked" -> CategoryError.Locked
        "not_found" -> CategoryError.NotFound
        "validation_failed" -> fields.firstOrNull { it.field == "name" }
            ?.let { CategoryError.InvalidName(it.toNameIssue()) }
            ?: CategoryError.Unexpected

        else -> CategoryError.Unexpected
    }
}

private fun FieldError.toNameIssue(): CategoryNameIssue = when (code) {
    "required" -> CategoryNameIssue.REQUIRED
    "max_length", "max" -> CategoryNameIssue.TOO_LONG
    "already_exists" -> CategoryNameIssue.ALREADY_EXISTS
    else -> CategoryNameIssue.INVALID
}
