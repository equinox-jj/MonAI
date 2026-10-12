package com.djtech.monai.feature.wallets.data.mapper

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import com.djtech.monai.feature.wallets.domain.model.WalletError
import java.time.Instant

fun WalletDto.asModel(): Wallet = Wallet(
    id = id,
    providerId = providerId,
    name = name,
    type = type,
    logoUrl = logoUrl,
    initialBalance = initialBalance,
    currentBalance = currentBalance,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = Instant.parse(createdAt),
    updatedAt = Instant.parse(updatedAt),
)

// Reads only fail offline or unexpectedly; write error codes are mapped once wallets can be edited.
fun ApiError.toWalletError(): WalletError = when (this) {
    ApiError.Network -> WalletError.Network
    is ApiError.Http, is ApiError.Unknown -> WalletError.Unexpected
}
