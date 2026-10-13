package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.runtime.Composable
import com.djtech.monai.feature.wallets.presentation.common.WalletArchiveInsteadDialog
import com.djtech.monai.feature.wallets.presentation.common.WalletDeleteDialog
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailIntent
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletDetailDialog

/** Confirms a delete, or offers to archive once a delete was refused for a wallet with transactions. */
@Composable
internal fun WalletDetailDialogs(
    dialog: WalletDetailDialog?,
    walletName: String,
    onIntent: (WalletDetailIntent) -> Unit,
) {
    val dismiss = { onIntent(WalletDetailIntent.DismissDialog) }
    when (dialog) {
        null -> Unit
        WalletDetailDialog.ConfirmDelete ->
            WalletDeleteDialog(
                walletName,
                onConfirm = { onIntent(WalletDetailIntent.ConfirmDelete) },
                onDismiss = dismiss,
            )

        WalletDetailDialog.ArchiveInstead ->
            WalletArchiveInsteadDialog(
                walletName,
                onConfirm = { onIntent(WalletDetailIntent.ConfirmArchive) },
                onDismiss = dismiss,
            )
    }
}
