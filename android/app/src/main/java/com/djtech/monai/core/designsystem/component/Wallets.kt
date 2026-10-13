package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.walletMonogram
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.designsystem.theme.WalletGradient
import com.djtech.monai.core.designsystem.theme.WalletGradients
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import java.time.Instant

/** "Cash", "Bank", "E-wallet", "Other". */
@Composable
@ReadOnlyComposable
fun WalletType.label(): String = stringResource(
    when (this) {
        WalletType.CASH -> R.string.wallet_type_cash
        WalletType.BANK -> R.string.wallet_type_bank
        WalletType.E_WALLET -> R.string.wallet_type_e_wallet
        WalletType.OTHER -> R.string.wallet_type_other
    },
)

/** The type's own card gradient, used when a wallet has no color of its own. */
fun WalletType.gradient(dark: Boolean): WalletGradient = when (this) {
    WalletType.BANK -> WalletGradients.bank(dark)
    WalletType.E_WALLET -> WalletGradients.eWallet(dark)
    WalletType.CASH -> WalletGradients.cash(dark)
    WalletType.OTHER -> WalletGradients.bankAlt(dark)
}

/** The wallet's picked card color, else its type's. */
fun Wallet.gradient(dark: Boolean): WalletGradient =
    WalletColor.fromHex(color)?.gradient(dark) ?: type.gradient(dark)

/** A wallet's monogram on its card color, as in the wallet pickers; gray once archived. */
@Composable
fun WalletMonogram(wallet: Wallet, size: Dp, modifier: Modifier = Modifier) {
    val container = if (wallet.isArchived) {
        MonAITheme.colors.textDisabled
    } else {
        wallet.gradient(MonAITheme.colors.isDark).start
    }
    MonAIMonogram(
        walletMonogram(wallet.name),
        modifier,
        containerColor = container,
        contentColor = Color.White,
        size = size,
    )
}

/**
 * A wallet on its gradient: monogram, name, the "Default" pill, then the balance at the bottom.
 * Size it with [modifier]; the balance sits at the bottom whatever the height.
 *
 * @param balance already formatted, or the hidden-amount mask.
 * @param caption a line under the name, e.g. the type.
 * @param balanceLabel a line above the balance, e.g. "Current balance".
 * @param selected rings the card, for the wallet shown in the tablet detail pane.
 */
@Composable
fun MonAIWalletCard(
    wallet: Wallet,
    balance: String,
    modifier: Modifier = Modifier,
    caption: String? = null,
    balanceLabel: String? = null,
    balanceStyle: TextStyle = MonAITheme.extendedTypography.amountLarge,
    monogramSize: Dp = MonAITheme.sizes.avatarSmall,
    elevated: Boolean = false,
    selected: Boolean = false,
    onClick: (() -> Unit)? = null,
) {
    val gradient = wallet.gradient(MonAITheme.colors.isDark)
    val spacing = MonAITheme.spacing
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    MonAIGradientCard(
        modifier.then(
            if (selected) {
                Modifier.border(MonAITheme.sizes.borderFocused, MonAITheme.colors.focus, shape)
            } else {
                Modifier
            },
        ),
        brush = gradient.brush,
        cornerRadius = MonAITheme.radius.lg,
        contentPadding = PaddingValues(spacing.cardPadding),
        elevated = elevated,
        decorated = false,
        onClick = onClick,
        verticalArrangement = Arrangement.Top,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
        ) {
            MonAIMonogram(walletMonogram(wallet.name), contentColor = gradient.start, size = monogramSize)
            Column(Modifier.weight(1f)) {
                Text(
                    wallet.name,
                    style = MonAITheme.typography.titleMedium,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                if (caption != null) {
                    Text(caption, style = MonAITheme.typography.bodySmall, color = gradient.muted)
                }
            }
            if (wallet.isDefault) MonAIPill(stringResource(R.string.wallet_default))
        }
        // The card's column wraps its content, so a spacer pushes the balance to the bottom.
        Spacer(Modifier.weight(1f))
        Column {
            if (balanceLabel != null) {
                Text(balanceLabel, style = MonAITheme.typography.bodySmall, color = gradient.muted)
            }
            Text(balance, style = balanceStyle, maxLines = 1)
        }
    }
}

@PreviewLightDark
@Composable
private fun WalletCardPreview() {
    val wallet = Wallet(
        id = "bca",
        providerId = null,
        name = "BCA Tabungan",
        type = WalletType.BANK,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = 8_250_000,
        icon = null,
        color = null,
        isDefault = true,
        isArchived = false,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )
    MonAITheme {
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            MonAIWalletCard(
                wallet,
                formatRupiah(wallet.currentBalance),
                Modifier
                    .fillMaxWidth()
                    .height(124.dp),
                caption = WalletType.BANK.label(),
            )
            MonAIWalletCard(
                wallet.copy(name = "Mandiri", isDefault = false, color = WalletColor.Rose.hex),
                formatRupiah(2_565_000),
                Modifier.size(300.dp, 160.dp),
                balanceLabel = "Bank · balance",
                selected = true,
            )
        }
    }
}
