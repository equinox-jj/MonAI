package com.djtech.monai.feature.wallets.presentation.archivedwallets.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIListItem
import com.djtech.monai.core.designsystem.component.WalletMonogram
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Wallet

/** An archived wallet: gray monogram, "Bank · Rp 3.065.000", and Unarchive. */
@Composable
internal fun ArchivedWalletsRow(
    wallet: Wallet,
    isRestoring: Boolean,
    enabled: Boolean,
    onUnarchive: () -> Unit,
    showDivider: Boolean,
    modifier: Modifier = Modifier,
) {
    MonAIListItem(
        title = wallet.name,
        modifier = modifier,
        supporting = stringResource(
            R.string.archived_wallets_meta,
            wallet.type.label(),
            formatRupiah(wallet.currentBalance),
        ),
        leading = { WalletMonogram(wallet, size = MonAITheme.sizes.avatarMedium) },
        trailing = {
            MonAIButton(
                stringResource(R.string.archived_wallets_unarchive),
                onClick = onUnarchive,
                variant = MonAIButtonVariant.Tonal,
                size = MonAIButtonSize.Small,
                leadingIcon = MonAIIcons.Unarchive,
                enabled = enabled,
                loading = isRestoring,
            )
        },
        showDivider = showDivider,
    )
}
