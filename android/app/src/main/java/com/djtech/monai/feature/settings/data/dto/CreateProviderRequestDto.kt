package com.djtech.monai.feature.settings.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Body of `POST /admin/payment-providers`; the server makes the slug from the name. */
@Serializable
data class CreateProviderRequestDto(
    @SerialName("name") val name: String,
    @SerialName("type") val type: WalletType,
    @SerialName("aliases") val aliases: List<String>,
    @SerialName("sort_order") val sortOrder: Int,
)
