package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailIntent
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailState

/** The top bar's overflow: "Make default" and "Delete", when the wallet allows them. */
@Composable
internal fun WalletDetailMenu(state: WalletDetailState, onIntent: (WalletDetailIntent) -> Unit) {
    if (!state.canSetDefault && !state.canDelete) return
    // Whether the menu is open is view state only, so it stays out of the ViewModel.
    var expanded by rememberSaveable { mutableStateOf(false) }
    Box {
        MonAIIconButton(
            MonAIIcons.MoreVert,
            stringResource(R.string.wallet_detail_more),
            onClick = { expanded = true },
            enabled = !state.isWorking,
        )
        DropdownMenu(
            expanded = expanded,
            onDismissRequest = { expanded = false },
            containerColor = MonAITheme.colors.surface,
        ) {
            if (state.canSetDefault) {
                DropdownMenuItem(
                    text = { Text(stringResource(R.string.wallet_detail_set_default)) },
                    onClick = {
                        expanded = false
                        onIntent(WalletDetailIntent.SetDefault)
                    },
                )
            }
            if (state.canDelete) {
                DropdownMenuItem(
                    text = {
                        Text(stringResource(R.string.wallet_detail_delete), color = MonAITheme.colors.errorText)
                    },
                    onClick = {
                        expanded = false
                        onIntent(WalletDetailIntent.Delete)
                    },
                )
            }
        }
    }
}
