package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.feature.wallets.presentation.common.WalletArchiveInsteadDialog
import com.djtech.monai.feature.wallets.presentation.common.WalletDeleteDialog
import com.djtech.monai.feature.wallets.presentation.walletform.WalletFormIntent
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormDialog

/** Discard changes, confirm a delete, or archive instead once a delete was refused. */
@Composable
internal fun WalletFormDialogs(
    dialog: WalletFormDialog?,
    walletName: String,
    onIntent: (WalletFormIntent) -> Unit,
) {
    val dismiss = { onIntent(WalletFormIntent.DismissDialog) }
    when (dialog) {
        null -> Unit
        WalletFormDialog.Discard -> MonAIAlertDialog(
            title = stringResource(R.string.wallet_form_discard_title),
            message = stringResource(R.string.wallet_form_discard_body),
            confirmLabel = stringResource(R.string.wallet_form_discard_confirm),
            onConfirm = { onIntent(WalletFormIntent.ConfirmDiscard) },
            onDismissRequest = { onIntent(WalletFormIntent.KeepEditing) },
            dismissLabel = stringResource(R.string.wallet_form_keep_editing),
            destructive = true,
        )

        WalletFormDialog.ConfirmDelete -> WalletDeleteDialog(
            walletName,
            onConfirm = { onIntent(WalletFormIntent.ConfirmDelete) },
            onDismiss = dismiss,
        )

        WalletFormDialog.ArchiveInstead -> WalletArchiveInsteadDialog(
            walletName,
            onConfirm = { onIntent(WalletFormIntent.ConfirmArchive) },
            onDismiss = dismiss,
        )
    }
}
