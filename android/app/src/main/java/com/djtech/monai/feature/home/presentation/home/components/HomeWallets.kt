package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAISectionHeader
import com.djtech.monai.core.designsystem.component.MonAIWalletCard
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeIntent
import com.djtech.monai.feature.home.presentation.home.HomeTestTags

/** "Wallets" with a horizontal row of cards that runs to the screen edge. */
@Composable
internal fun HomeWallets(
    wallets: List<Wallet>,
    isBalanceHidden: Boolean,
    onIntent: (HomeIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val horizontal = MonAITheme.spacing.screenHorizontal
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.sectionContentGap)) {
        MonAISectionHeader(
            stringResource(R.string.home_wallets),
            Modifier.padding(horizontal = horizontal),
            actionLabel = stringResource(R.string.home_see_all),
            onActionClick = { onIntent(HomeIntent.Open(HomeDestination.Wallets)) },
        )
        LazyRow(
            Modifier.testTag(HomeTestTags.WALLETS),
            contentPadding = PaddingValues(horizontal = horizontal),
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            items(wallets, key = Wallet::id) { wallet ->
                WalletCard(
                    wallet,
                    isBalanceHidden,
                    onClick = { onIntent(HomeIntent.Open(HomeDestination.WalletDetail(wallet.id))) },
                )
            }
        }
    }
}

@Composable
private fun WalletCard(wallet: Wallet, isBalanceHidden: Boolean, onClick: () -> Unit) {
    val hiddenAmount = stringResource(R.string.home_hidden_amount)
    MonAIWalletCard(
        wallet,
        balance = if (isBalanceHidden) hiddenAmount else formatRupiah(wallet.currentBalance),
        modifier = Modifier.size(MonAITheme.sizes.walletCardWidth, MonAITheme.sizes.walletCardHeight),
        balanceLabel = stringResource(R.string.home_wallet_balance, wallet.type.label()),
        onClick = onClick,
    )
}
