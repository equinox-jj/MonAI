package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet

/** One wallet to filter by. Archived wallets are listed last and dimmed: their history stays. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionWalletFilterSheet(
    sheet: FilterSheet.Wallet,
    wallets: List<Wallet>,
    onIntent: (FilterIntent) -> Unit,
) {
    MonAIBottomSheet(
        onDismissRequest = { onIntent(FilterIntent.Dismiss) },
        title = stringResource(R.string.transactions_sheet_wallets),
    ) {
        Column(
            Modifier
                .heightIn(max = 400.dp)
                .verticalScroll(rememberScrollState())
                .selectableGroup(),
        ) {
            wallets.sortedBy(Wallet::isArchived).forEach { wallet ->
                WalletOption(
                    wallet,
                    selected = wallet.id == sheet.selectedId,
                    onClick = { onIntent(FilterIntent.PickWallet(wallet.id)) },
                )
            }
        }
        TransactionSheetButtons(
            secondaryLabel = stringResource(R.string.transactions_sheet_clear),
            onSecondary = { onIntent(FilterIntent.ClearSheet) },
            primaryLabel = stringResource(
                if (sheet.selectedId == null) {
                    R.string.transactions_sheet_show_all
                } else {
                    R.string.transactions_sheet_apply
                },
            ),
            onPrimary = { onIntent(FilterIntent.Apply) },
        )
    }
}

@Composable
private fun WalletOption(wallet: Wallet, selected: Boolean, onClick: () -> Unit) {
    val colors = MonAITheme.colors
    Column {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .defaultMinSize(minHeight = MonAITheme.sizes.settingsRow)
                .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
                .alpha(if (wallet.isArchived) 0.75f else 1f)
                .padding(vertical = MonAITheme.spacing.x2),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            WalletMonogram(wallet, size = 36.dp)
            Column(Modifier.weight(1f)) {
                Text(
                    wallet.name,
                    style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                    color = colors.textPrimary,
                )
                Text(
                    if (wallet.isArchived) {
                        stringResource(R.string.transactions_wallet_archived)
                    } else {
                        wallet.type.label()
                    },
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
            }
            Icon(
                if (selected) MonAIIcons.RadioButtonChecked else MonAIIcons.RadioButtonUnchecked,
                null,
                tint = if (selected) colors.accent else colors.textDisabled,
            )
        }
        MonAIDivider()
    }
}
