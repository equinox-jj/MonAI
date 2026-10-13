package com.djtech.monai.feature.wallets.presentation.archivedwallets.preview

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.presentation.archivedwallets.ArchivedWalletsState
import com.djtech.monai.feature.wallets.presentation.wallets.preview.WalletsPreviewData

internal object ArchivedWalletsPreviewData {
    val list = ArchivedWalletsState(
        wallets = listOf(
            WalletsPreviewData.wallet("mandiri", "Mandiri", WalletType.BANK, 3_065_000, isArchived = true),
            WalletsPreviewData.wallet("ovo", "OVO", WalletType.E_WALLET, 15_000, isArchived = true),
        ),
    )
}
