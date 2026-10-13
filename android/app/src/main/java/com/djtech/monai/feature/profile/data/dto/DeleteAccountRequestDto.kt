package com.djtech.monai.feature.profile.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `DELETE /me` body. */
@Serializable
data class DeleteAccountRequestDto(
    @SerialName("password") val password: String,
)
