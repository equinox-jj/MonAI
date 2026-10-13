package com.djtech.monai.feature.categories.data.dto

import com.djtech.monai.core.model.CategoryType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `POST /categories`; a null [icon] or [color] is left out. */
@Serializable
data class CreateCategoryRequestDto(
    @SerialName("name") val name: String,
    @SerialName("type") val type: CategoryType,
    @SerialName("icon") val icon: String? = null,
    @SerialName("color") val color: String? = null,
)
