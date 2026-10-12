package com.djtech.monai.feature.categories.data.dto

import com.djtech.monai.core.model.CategoryType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CategoryDto(
    @SerialName("id") val id: String,
    @SerialName("name") val name: String,
    @SerialName("type") val type: CategoryType,
    @SerialName("icon") val icon: String? = null,
    @SerialName("color") val color: String? = null,
    @SerialName("is_default") val isDefault: Boolean,
    @SerialName("is_system") val isSystem: Boolean,
    @SerialName("is_hidden") val isHidden: Boolean,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
)
