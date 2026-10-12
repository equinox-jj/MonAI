package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIGradientCard
import com.djtech.monai.core.designsystem.component.MonAIMonogram
import com.djtech.monai.core.designsystem.component.MonAIPill
import com.djtech.monai.core.designsystem.component.MonAISectionHeader
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletGradient
import com.djtech.monai.core.designsystem.theme.WalletGradients
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeIntent
import com.djtech.monai.feature.home.presentation.home.HomeTestTags
import com.djtech.monai.feature.home.presentation.home.mapper.walletMonogram

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
    val gradient = wallet.type.gradient(MonAITheme.colors.isDark)
    val spacing = MonAITheme.spacing
    val hiddenAmount = stringResource(R.string.home_hidden_amount)
    val balance = if (isBalanceHidden) hiddenAmount else formatRupiah(wallet.currentBalance)
    MonAIGradientCard(
        Modifier.size(MonAITheme.sizes.walletCardWidth, MonAITheme.sizes.walletCardHeight),
        brush = gradient.brush,
        cornerRadius = MonAITheme.radius.lg,
        contentPadding = PaddingValues(spacing.cardPadding),
        elevated = false,
        decorated = false,
        onClick = onClick,
        verticalArrangement = Arrangement.Top,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
        ) {
            MonAIMonogram(
                walletMonogram(wallet.name),
                contentColor = gradient.start,
                size = MonAITheme.sizes.avatarSmall,
            )
            Text(
                wallet.name,
                Modifier.weight(1f),
                style = MonAITheme.typography.titleMedium,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
            if (wallet.isDefault) MonAIPill(stringResource(R.string.home_wallet_default))
        }
        // The card's column wraps its content, so a spacer pushes the balance to the bottom.
        Spacer(Modifier.weight(1f))
        Column {
            Text(
                stringResource(R.string.home_wallet_balance, wallet.type.label()),
                style = MonAITheme.typography.bodySmall,
                color = gradient.muted,
            )
            Text(
                balance,
                style = MonAITheme.extendedTypography.amountLarge,
                maxLines = 1,
            )
        }
    }
}

private fun WalletType.gradient(dark: Boolean): WalletGradient = when (this) {
    WalletType.BANK -> WalletGradients.bank(dark)
    WalletType.E_WALLET -> WalletGradients.eWallet(dark)
    WalletType.CASH -> WalletGradients.cash(dark)
    WalletType.OTHER -> WalletGradients.bankAlt(dark)
}
