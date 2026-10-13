package com.djtech.monai.feature.wallets.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Confirms deleting a wallet, from its detail or its edit form. */
@Composable
internal fun WalletDeleteDialog(walletName: String, onConfirm: () -> Unit, onDismiss: () -> Unit) {
    MonAIAlertDialog(
        title = stringResource(R.string.wallets_delete_title, walletName),
        message = stringResource(R.string.wallets_delete_body),
        confirmLabel = stringResource(R.string.wallets_delete_confirm),
        onConfirm = onConfirm,
        onDismissRequest = onDismiss,
        dismissLabel = stringResource(R.string.wallets_cancel),
        icon = MonAIIcons.Delete,
        tone = MonAIAlertTone.Error,
        destructive = true,
    )
}

/** Offers to archive once a delete was refused because the wallet has transactions. */
@Composable
internal fun WalletArchiveInsteadDialog(walletName: String, onConfirm: () -> Unit, onDismiss: () -> Unit) {
    MonAIAlertDialog(
        title = stringResource(R.string.wallets_archive_instead_title, walletName),
        message = stringResource(R.string.wallets_archive_instead_body, walletName),
        confirmLabel = stringResource(R.string.wallet_detail_archive),
        onConfirm = onConfirm,
        onDismissRequest = onDismiss,
        dismissLabel = stringResource(R.string.wallets_cancel),
        icon = MonAIIcons.Inventory2,
        tone = MonAIAlertTone.Warning,
    ) {
        Column(
            Modifier
                .fillMaxWidth()
                .background(MonAITheme.colors.background, RoundedCornerShape(MonAITheme.radius.md))
                .padding(MonAITheme.spacing.x3),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            Kept(stringResource(R.string.wallets_archive_instead_keeps_history))
            Kept(stringResource(R.string.wallets_archive_instead_reversible))
        }
    }
}

@Composable
private fun Kept(text: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Icon(
            MonAIIcons.CheckCircle,
            contentDescription = null,
            modifier = Modifier.size(MonAITheme.sizes.iconMd),
            tint = MonAITheme.colors.success,
        )
        Text(
            text,
            style = MonAITheme.extendedTypography.bodyCompact,
            color = MonAITheme.colors.textSecondary,
        )
    }
}
