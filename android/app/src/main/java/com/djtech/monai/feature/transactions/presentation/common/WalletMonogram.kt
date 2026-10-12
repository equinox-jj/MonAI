package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.Dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.walletMonogram
import com.djtech.monai.core.designsystem.component.MonAIMonogram
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletGradients
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType

/** A wallet's monogram on its type's color, as in the wallet pickers; gray once archived. */
@Composable
internal fun WalletMonogram(wallet: Wallet, size: Dp, modifier: Modifier = Modifier) {
    val dark = MonAITheme.colors.isDark
    val container: Color = when {
        wallet.isArchived -> MonAITheme.colors.textDisabled
        wallet.type == WalletType.E_WALLET -> WalletGradients.eWallet(dark).start
        wallet.type == WalletType.CASH -> WalletGradients.cash(dark).start
        else -> WalletGradients.bank(dark).start
    }
    MonAIMonogram(
        walletMonogram(wallet.name),
        modifier,
        containerColor = container,
        contentColor = Color.White,
        size = size,
    )
}

@Composable
@ReadOnlyComposable
internal fun WalletType.label(): String = stringResource(
    when (this) {
        WalletType.CASH -> R.string.home_wallet_type_cash
        WalletType.BANK -> R.string.home_wallet_type_bank
        WalletType.E_WALLET -> R.string.home_wallet_type_e_wallet
        WalletType.OTHER -> R.string.home_wallet_type_other
    },
)
