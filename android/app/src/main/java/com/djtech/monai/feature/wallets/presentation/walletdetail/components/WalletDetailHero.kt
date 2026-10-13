package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIWalletCard
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.Wallet

/** The wallet's card with its current balance. */
@Composable
internal fun WalletDetailHero(wallet: Wallet, modifier: Modifier = Modifier) {
    MonAIWalletCard(
        wallet,
        balance = formatRupiah(wallet.currentBalance),
        modifier = modifier
            .fillMaxWidth()
            .height(176.dp),
        caption = wallet.type.label(),
        balanceLabel = stringResource(R.string.wallet_detail_current_balance),
        balanceStyle = MonAITheme.typography.displaySmall.tabular(),
        monogramSize = 36.dp,
        elevated = !wallet.isArchived,
    )
}
