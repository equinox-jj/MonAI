package com.djtech.monai.feature.wallets.presentation.walletform.preview

import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.presentation.walletform.WalletFormState
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormMode
import com.djtech.monai.feature.wallets.presentation.wallets.preview.WalletsPreviewData

internal object WalletFormPreviewData {

    private val providers = listOf(
        provider("cash", "Cash", WalletType.CASH),
        provider("bca", "BCA", WalletType.BANK),
        provider("mandiri", "Bank Mandiri", WalletType.BANK),
        provider("bri", "BRI", WalletType.BANK),
        provider("bni", "BNI", WalletType.BANK),
        provider("gopay", "GoPay", WalletType.E_WALLET),
        provider("ovo", "OVO", WalletType.E_WALLET),
        provider("dana", "DANA", WalletType.E_WALLET),
        provider("shopeepay", "ShopeePay", WalletType.E_WALLET),
    )

    val add = WalletFormState(
        mode = WalletFormMode.Add,
        providers = providers,
        providerSlug = "bca",
        name = "BCA",
        type = WalletType.BANK,
        isTypeLocked = true,
        initialBalance = 1_250_000,
        defaultWalletName = "BCA Tabungan",
    )

    private val mandiri = WalletsPreviewData.wallet("mandiri", "Mandiri", WalletType.BANK, 2_565_000)
        .copy(providerId = "p-mandiri", initialBalance = 2_000_000)

    val edit = WalletFormState(
        mode = WalletFormMode.Edit("mandiri"),
        name = "Mandiri",
        type = WalletType.BANK,
        isTypeLocked = true,
        initialBalance = 2_500_000,
        color = WalletColor.Indigo,
        wallet = mandiri,
        defaultWalletName = "BCA Tabungan",
    )

    private fun provider(slug: String, name: String, type: WalletType) = PaymentProvider(
        id = "",
        slug = slug,
        name = name,
        type = type,
        logoUrl = null,
        aliases = emptyList(),
        sortOrder = 0,
    )
}
