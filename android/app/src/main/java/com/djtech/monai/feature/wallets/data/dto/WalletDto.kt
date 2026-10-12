package com.djtech.monai.feature.wallets.data.dto

import com.djtech.monai.core.model.WalletType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class WalletDto(
    @SerialName("id") val id: String,
    @SerialName("provider_id") val providerId: String? = null,
    @SerialName("name") val name: String,
    @SerialName("type") val type: WalletType,
    @SerialName("logo_url") val logoUrl: String? = null,
    @SerialName("initial_balance") val initialBalance: Long,
    @SerialName("current_balance") val currentBalance: Long,
    @SerialName("icon") val icon: String? = null,
    @SerialName("color") val color: String? = null,
    @SerialName("is_default") val isDefault: Boolean,
    @SerialName("is_archived") val isArchived: Boolean,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
)
