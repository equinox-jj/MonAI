package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailIntent
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailState

/**
 * Edit, Transfer, and Archive (Unarchive once archived), with a note under them saying why
 * archiving or transferring isn't possible.
 */
@Composable
internal fun WalletDetailActions(
    state: WalletDetailState,
    onIntent: (WalletDetailIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val wallet = state.wallet ?: return
    val enabled = !state.isWorking
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            val tile = Modifier.weight(1f)
            ActionTile(
                MonAIIcons.Edit,
                stringResource(R.string.wallet_detail_edit),
                onClick = { onIntent(WalletDetailIntent.Edit) },
                modifier = tile,
            )
            ActionTile(
                MonAIIcons.SwapHoriz,
                stringResource(R.string.wallet_detail_transfer_action),
                onClick = { onIntent(WalletDetailIntent.Transfer) },
                modifier = tile,
                enabled = state.canTransfer,
            )
            if (state.canUnarchive) {
                ActionTile(
                    MonAIIcons.Unarchive,
                    stringResource(R.string.wallet_detail_unarchive),
                    onClick = { onIntent(WalletDetailIntent.Unarchive) },
                    modifier = tile,
                    enabled = enabled,
                )
            } else {
                ActionTile(
                    MonAIIcons.Inventory2,
                    stringResource(R.string.wallet_detail_archive),
                    onClick = { onIntent(WalletDetailIntent.Archive) },
                    modifier = tile,
                    enabled = enabled && state.canArchive,
                )
            }
        }
        val hint = when {
            wallet.isArchived -> R.string.wallet_detail_archived_hint
            wallet.isDefault -> R.string.wallet_detail_default_hint
            else -> null
        }
        if (hint != null) {
            Text(
                stringResource(hint),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
            )
        }
    }
}

@Composable
private fun ActionTile(
    icon: ImageVector,
    label: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    Surface(
        onClick = onClick,
        modifier = modifier.height(64.dp),
        enabled = enabled,
        shape = RoundedCornerShape(MonAITheme.radius.md),
        color = if (enabled) colors.surface else colors.background,
        border = BorderStroke(MonAITheme.sizes.border, colors.border),
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1, Alignment.CenterVertically),
        ) {
            Icon(
                icon,
                contentDescription = null,
                modifier = Modifier.size(MonAITheme.sizes.iconLg),
                tint = if (enabled) colors.accent else colors.textDisabled,
            )
            Text(
                label,
                style = MonAITheme.typography.labelMedium,
                color = if (enabled) colors.textSecondary else colors.textDisabled,
            )
        }
    }
}
