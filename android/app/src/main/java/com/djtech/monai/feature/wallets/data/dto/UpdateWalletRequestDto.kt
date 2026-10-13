package com.djtech.monai.feature.wallets.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `PATCH /wallets/{id}`. NetworkJson leaves nulls out, so only the changed fields are sent. */
@Serializable
data class UpdateWalletRequestDto(
    @SerialName("name") val name: String? = null,
    @SerialName("type") val type: WalletType? = null,
    @SerialName("initial_balance") val initialBalance: Long? = null,
    @SerialName("color") val color: String? = null,
    @SerialName("is_default") val isDefault: Boolean? = null,
    @SerialName("is_archived") val isArchived: Boolean? = null,
)
