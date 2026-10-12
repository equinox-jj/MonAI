package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIRadioOption
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.presentation.common.WalletMonogram
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormIntent
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget

/** Wallets that are not archived, with their balances; the title says which side is being picked. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun TransactionFormWalletPickerSheet(
    sheet: FormSheet.Wallet,
    type: TransactionType,
    wallets: List<Wallet>,
    onIntent: (TransactionFormIntent) -> Unit,
) {
    val title = stringResource(
        when {
            sheet.target == WalletTarget.DESTINATION -> R.string.transaction_picker_transfer_to
            type == TransactionType.TRANSFER -> R.string.transaction_picker_transfer_from
            type == TransactionType.INCOME -> R.string.transaction_picker_receive_into
            else -> R.string.transaction_picker_pay_from
        },
    )
    MonAIBottomSheet(onDismissRequest = { onIntent(TransactionFormIntent.DismissSheet) }, title = title) {
        Column(
            Modifier
                .heightIn(max = 420.dp)
                .verticalScroll(rememberScrollState())
                .selectableGroup(),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            if (wallets.isEmpty()) {
                Text(
                    stringResource(R.string.transaction_picker_no_wallets),
                    style = MonAITheme.typography.bodyMedium,
                    color = MonAITheme.colors.textTertiary,
                )
            }
            wallets.forEach { wallet ->
                MonAIRadioOption(
                    title = wallet.name,
                    selected = wallet.id == sheet.selectedId,
                    onClick = { onIntent(TransactionFormIntent.SheetPickWallet(wallet.id)) },
                    subtitle = formatRupiah(wallet.currentBalance),
                    tag = if (wallet.isDefault) stringResource(R.string.transaction_picker_default) else null,
                    leading = { WalletMonogram(wallet, size = MonAITheme.sizes.avatarMedium) },
                )
            }
        }
        Text(
            stringResource(R.string.transaction_picker_archived_note),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
        MonAIButton(
            stringResource(R.string.transaction_picker_done),
            onClick = { onIntent(TransactionFormIntent.ConfirmSheet) },
            modifier = Modifier.fillMaxWidth(),
        )
    }
}
