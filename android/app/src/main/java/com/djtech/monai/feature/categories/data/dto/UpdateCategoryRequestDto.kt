package com.djtech.monai.feature.categories.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `PATCH /categories/{id}`; null fields are left out, so they don't change. */
@Serializable
data class UpdateCategoryRequestDto(
    @SerialName("name") val name: String? = null,
    @SerialName("icon") val icon: String? = null,
    @SerialName("color") val color: String? = null,
    @SerialName("is_hidden") val isHidden: Boolean? = null,
)
