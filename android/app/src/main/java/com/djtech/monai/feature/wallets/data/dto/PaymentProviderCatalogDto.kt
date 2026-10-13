package com.djtech.monai.feature.wallets.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `GET /payment-providers`; [version] changes whenever the catalog does. */
@Serializable
data class PaymentProviderCatalogDto(
    @SerialName("version") val version: Long,
    @SerialName("providers") val providers: List<PaymentProviderDto>,
)
