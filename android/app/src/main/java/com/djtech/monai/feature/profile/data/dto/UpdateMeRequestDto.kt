package com.djtech.monai.feature.profile.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `PATCH /me`. Null fields are left out (NetworkJson has explicitNulls off), so they don't change. */
@Serializable
data class UpdateMeRequestDto(
    @SerialName("name") val name: String? = null,
    @SerialName("timezone") val timezone: String? = null,
)
