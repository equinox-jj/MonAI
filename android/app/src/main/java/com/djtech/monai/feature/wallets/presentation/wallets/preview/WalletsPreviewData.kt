package com.djtech.monai.feature.wallets.presentation.wallets.preview

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.domain.model.balanceSharesByType
import com.djtech.monai.feature.wallets.domain.model.totalBalance
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsState
import java.time.Instant

internal object WalletsPreviewData {

    val wallets = listOf(
        wallet("bca", "BCA Tabungan", WalletType.BANK, 8_250_000, isDefault = true),
        wallet("mandiri", "Mandiri", WalletType.BANK, 2_565_000),
        wallet("gopay", "GoPay", WalletType.E_WALLET, 1_185_000),
        wallet("cash", "Cash", WalletType.CASH, 450_000),
    )

    val list = WalletsState(
        isLoading = false,
        wallets = wallets,
        totalBalance = wallets.totalBalance(),
        shares = wallets.balanceSharesByType(),
        archivedCount = 1,
        selectedId = "bca",
    )

    fun wallet(
        id: String,
        name: String,
        type: WalletType,
        balance: Long,
        isDefault: Boolean = false,
        isArchived: Boolean = false,
        color: String? = null,
    ) = Wallet(
        id = id,
        providerId = null,
        name = name,
        type = type,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = balance,
        icon = null,
        color = color,
        isDefault = isDefault,
        isArchived = isArchived,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )
}
