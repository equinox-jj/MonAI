package com.djtech.monai.feature.wallets.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * One entry of the bundled `payment_providers_seed.json`. Server ids are generated per database,
 * so the seed only has the slug; logos come with the first catalog refresh.
 */
@Serializable
data class SeedPaymentProviderDto(
    @SerialName("slug") val slug: String,
    @SerialName("name") val name: String,
    @SerialName("type") val type: WalletType,
    @SerialName("aliases") val aliases: List<String> = emptyList(),
    @SerialName("sort_order") val sortOrder: Int,
)
