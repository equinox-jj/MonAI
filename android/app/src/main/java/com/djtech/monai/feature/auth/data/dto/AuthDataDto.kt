package com.djtech.monai.feature.auth.data.dto

import com.djtech.monai.core.network.model.UserDto
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class AuthDataDto(
    @SerialName("access_token") val accessToken: String,
    @SerialName("token_type") val tokenType: String,
    @SerialName("expires_in") val expiresIn: Long,
    @SerialName("user") val user: UserDto,
)
