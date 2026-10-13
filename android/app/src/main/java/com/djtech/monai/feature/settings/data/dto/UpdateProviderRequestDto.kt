package com.djtech.monai.feature.settings.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `PATCH /admin/payment-providers/{id}`; null fields are left out, so they don't change. */
@Serializable
data class UpdateProviderRequestDto(
    @SerialName("name") val name: String? = null,
    @SerialName("type") val type: WalletType? = null,
    @SerialName("aliases") val aliases: List<String>? = null,
    @SerialName("sort_order") val sortOrder: Int? = null,
)
