package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIWalletCard
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.Wallet

/** The design's wallet card height on the Wallets list. */
internal val WALLET_CARD_HEIGHT = 124.dp

/** One wallet in the list: its gradient, name and type, the default pill and its balance. */
@Composable
internal fun WalletsCard(
    wallet: Wallet,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAIWalletCard(
        wallet,
        balance = formatRupiah(wallet.currentBalance),
        modifier = modifier
            .fillMaxWidth()
            .height(WALLET_CARD_HEIGHT),
        caption = wallet.type.label(),
        balanceStyle = MonAITheme.typography.headlineMedium.tabular(),
        selected = selected,
        onClick = onClick,
    )
}
