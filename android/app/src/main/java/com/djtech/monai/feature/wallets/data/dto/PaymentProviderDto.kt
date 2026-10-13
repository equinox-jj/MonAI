package com.djtech.monai.feature.wallets.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PaymentProviderDto(
    @SerialName("id") val id: String,
    @SerialName("slug") val slug: String,
    @SerialName("name") val name: String,
    @SerialName("type") val type: WalletType,
    @SerialName("logo_url") val logoUrl: String? = null,
    @SerialName("aliases") val aliases: List<String> = emptyList(),
    @SerialName("sort_order") val sortOrder: Int,
)
