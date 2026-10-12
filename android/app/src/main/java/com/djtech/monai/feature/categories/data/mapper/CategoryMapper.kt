package com.djtech.monai.feature.categories.data.mapper

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.domain.model.CategoryError
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

// Reads only fail offline or unexpectedly; write error codes are mapped once categories can be edited.
fun ApiError.toCategoryError(): CategoryError = when (this) {
    ApiError.Network -> CategoryError.Network
    is ApiError.Http, is ApiError.Unknown -> CategoryError.Unexpected
}
