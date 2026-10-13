package com.djtech.monai.feature.wallets.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `POST /wallets`. Null fields are left out; with a provider, the server fills name and type from it. */
@Serializable
data class CreateWalletRequestDto(
    @SerialName("provider_id") val providerId: String?,
    @SerialName("name") val name: String,
    @SerialName("type") val type: WalletType?,
    @SerialName("initial_balance") val initialBalance: Long,
    @SerialName("color") val color: String?,
    @SerialName("is_default") val isDefault: Boolean,
)
