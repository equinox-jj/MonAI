package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIWalletCard
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.Wallet

/** The edited wallet's card as it will look: the new name, color and resulting balance. */
@Composable
internal fun WalletFormPreviewCard(
    wallet: Wallet,
    name: String,
    color: WalletColor?,
    balance: Long,
    modifier: Modifier = Modifier,
) {
    MonAIWalletCard(
        wallet.copy(name = name.ifBlank { wallet.name }, color = color?.hex ?: wallet.color, isDefault = false),
        balance = formatRupiah(balance),
        modifier = modifier
            .fillMaxWidth()
            .height(112.dp),
        balanceStyle = MonAITheme.typography.headlineMedium.tabular(),
    )
}
