package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Archive and Delete at the bottom of the edit form; neither is offered for the default wallet. */
@Composable
internal fun WalletFormManageActions(
    canArchive: Boolean,
    canDelete: Boolean,
    enabled: Boolean,
    onArchive: () -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(modifier, horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        MonAIButton(
            stringResource(R.string.wallet_form_archive),
            onClick = onArchive,
            modifier = Modifier.weight(1f),
            variant = MonAIButtonVariant.Outlined,
            size = MonAIButtonSize.Medium,
            leadingIcon = MonAIIcons.Inventory2,
            enabled = enabled && canArchive,
        )
        MonAIButton(
            stringResource(R.string.wallet_form_delete),
            onClick = onDelete,
            modifier = Modifier.weight(1f),
            variant = MonAIButtonVariant.Outlined,
            size = MonAIButtonSize.Medium,
            leadingIcon = MonAIIcons.Delete,
            enabled = enabled && canDelete,
        )
    }
}
