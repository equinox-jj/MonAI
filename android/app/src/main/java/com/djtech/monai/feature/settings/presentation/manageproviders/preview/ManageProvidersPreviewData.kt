package com.djtech.monai.feature.settings.presentation.manageproviders.preview

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.presentation.manageproviders.ManageProvidersState
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderRow
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderStatus

internal object ManageProvidersPreviewData {
    val state = ManageProvidersState(
        isLoading = false,
        rows = listOf(
            row(
                "cash",
                "Cash",
                "Rp",
                WalletType.CASH,
                "cash, tunai, uang tunai",
                ProviderStatus.SYSTEM,
            ),
            row(
                "bca",
                "BCA",
                "BCA",
                WalletType.BANK,
                "bca, bank bca",
                ProviderStatus.ACTIVE,
            ),
            row(
                "gopay",
                "GoPay",
                "GP",
                WalletType.E_WALLET,
                "gopay, gpay, go-pay",
                ProviderStatus.ACTIVE,
            ),
            row(
                "ovo",
                "OVO",
                "OVO",
                WalletType.E_WALLET,
                "ovo",
                ProviderStatus.INACTIVE,
            ),
        ),
        totalCount = 4,
        canCreate = true,
        canEdit = true,
    )

    private fun row(
        id: String,
        name: String,
        monogram: String,
        type: WalletType,
        aliases: String,
        status: ProviderStatus,
    ) = ProviderRow(
        id = id,
        name = name,
        monogram = monogram,
        logoUrl = null,
        type = type,
        aliases = aliases,
        status = status,
    )
}
