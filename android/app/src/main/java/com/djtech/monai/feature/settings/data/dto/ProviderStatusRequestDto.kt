package com.djtech.monai.feature.settings.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `PATCH /admin/payment-providers/{id}/status`. */
@Serializable
data class ProviderStatusRequestDto(
    @SerialName("is_active") val isActive: Boolean,
)
